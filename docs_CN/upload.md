### 16. 上传：WeUpload

> 适用平台：通用 —— 手机、网页、桌面都好用，触屏上自动变大（[按平台选组件](platform.md)）

`WeUpload` 对标 `el-upload`。包里不带任何原生依赖，"怎么选文件"和"怎么上传"都由你传进来：

- `picker(multiple)` 打开文件选择器，返回 `List<WeUploadFile>`，通常用 `file_picker` 或 `image_picker` 实现；
- `uploader(file, onProgress)` 把文件传到服务器，过程中用 `onProgress(0~1)` 报进度，返回值会存进 `file.response`，抛异常表示失败。

组件负责剩下的事：类型、大小、数量检查，文件列表，进度条，失败重试和删除确认。

```dart
final images = WeUploadController();

WeUpload(
  controller: images,
  picker: (multiple) async {
    final r = await FilePicker.platform.pickFiles(
      allowMultiple: multiple,
      type: FileType.image,
      withData: true,
    );
    return [
      for (final f in r?.files ?? <PlatformFile>[])
        WeUploadFile(name: f.name, size: f.size, bytes: f.bytes, raw: f),
    ];
  },
  uploader: (file, onProgress) async {
    final res = await dio.post(
      '/upload',
      data: FormData.fromMap({'file': MultipartFile.fromBytes(file.bytes!, filename: file.name)}),
      onSendProgress: (sent, total) => onProgress(sent / total),
    );
    return res.data['url'];
  },
  multiple: true,
  accept: const ['image/*'],
  maxSize: 2 * 1024 * 1024,
  limit: 5,
  listType: WeUploadListType.pictureCard,
  tip: 'jpg / png，单张不超过 2 MB',
)
```

编辑已有记录时，用 `WeUploadFile.uploaded(name: ..., url: ...)` 把服务器上的文件放进 `WeUploadController([...])`，它们一开始就是成功状态。

#### 三种列表

| `listType` | 样子 |
| --- | --- |
| `text`（默认） | 按钮 + 每个文件一行，上传中显示进度条，悬停时出现删除 |
| `picture` | 每行带缩略图和文件大小 |
| `pictureCard` | 方形卡片墙，最后一张是"+"；悬停可预览、重试、删除；达到 `limit` 后"+"隐藏 |

`drag: true` 把按钮换成大号虚线区域。拖放文件本身需要平台插件，例如在桌面端用 `desktop_drop` 接收拖入的文件，再调用 `controller.addFiles(files)`，它会走和点击选择完全一样的检查流程。

#### 检查与回调

| 参数 | 说明 |
| --- | --- |
| `accept` | 允许的类型：扩展名（`.png` 或 `png`，不区分大小写）或 `image/*`；空表示不限 |
| `maxSize` | 单个文件最大字节数 |
| `limit` | 列表里最多几个；一次选多了会整批拒绝并调用 `onExceed` |
| `beforeUpload` | 最后一道检查，返回 `false` 丢弃该文件，可以是异步的 |
| `beforeRemove` | 删除前确认，返回 `false` 保留，可以弹 `WeMessageBox.confirm` |
| `onReject(file, reason)` | 类型或大小不合格；不传时弹一条 `WeMessage` 警告 |
| `onExceed(files)` | 超过 `limit`；不传时弹一条警告 |
| `onChanged` / `onSuccess` / `onError` | 列表变化、单个成功、单个失败 |
| `onPreview` | 点击文件；不传时图片会全屏预览 |
| `autoUpload` | `false` 时选完只进列表，等 `controller.submit()` 再统一上传 |
| `uploader` 为 `null` | 文件只留在本地，加入后直接算成功，适合和表单一起提交 |

#### 在表单里

放进 `WeFormItem` 后会继承禁用状态，列表变化时触发 `change` 校验：

```dart
WeFormItem(
  name: 'images',
  label: '商品主图',
  valueGetter: () => images.files,
  rules: [
    const WeRule(required: true, message: '至少上传一张主图'),
    WeRule(
      validator: (_) => images.files.any((f) => f.status == WeUploadStatus.uploading)
          ? '图片还在上传，请稍候'
          : null,
    ),
  ],
  onReset: images.clear,
  child: WeUpload(controller: images, picker: pick, uploader: upload),
)
```

`weFormatBytes(1536)` 返回 `1.5 KB`，可以用来写提示文字。
