import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../basics/we_image.dart';
import '../buttons/we_button.dart';
import '../data/we_progress.dart';
import '../feedback/we_message.dart';
import 'we_form.dart';

/// Where a [WeUploadFile] is in its upload.
enum WeUploadStatus { ready, uploading, success, fail }

/// How [WeUpload] lists its files.
enum WeUploadListType {
  /// One line per file. The default.
  text,

  /// One line per file with a thumbnail.
  picture,

  /// A wall of square cards, the trigger being the last card.
  pictureCard,
}

/// Why [WeUpload] refused a picked file.
enum WeUploadReject { accept, size }

/// A file in a [WeUpload] list.
///
/// Pickers create files as [WeUploadStatus.ready]; [WeUploadFile.uploaded]
/// describes one that is already on the server, e.g. when editing a record.
class WeUploadFile {
  WeUploadFile({required this.name, this.size, this.bytes, this.url, this.raw})
    : uid = _nextUid++;

  WeUploadFile.uploaded({required this.name, this.url, this.size, this.raw})
    : uid = _nextUid++,
      bytes = null,
      status = WeUploadStatus.success,
      percentage = 1;

  static int _nextUid = 0;

  final int uid;
  final String name;

  /// Size in bytes, checked against [WeUpload.maxSize].
  final int? size;

  /// File content; images with bytes get a thumbnail.
  final Uint8List? bytes;

  /// Remote address; images with a url get a thumbnail.
  final String? url;

  /// Whatever the picker returned, e.g. a `PlatformFile` or an `XFile`.
  final Object? raw;

  WeUploadStatus status = WeUploadStatus.ready;

  /// 0–1 while uploading.
  double percentage = 0;

  /// What the uploader returned on success.
  Object? response;

  /// What the uploader threw on failure.
  Object? error;

  String get extension {
    final int dot = name.lastIndexOf('.');
    return dot < 0 ? '' : name.substring(dot + 1).toLowerCase();
  }

  bool get isImage => _imageExtensions.contains(extension);

  @override
  String toString() => 'WeUploadFile($name, $status)';
}

const _imageExtensions = {'png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp', 'svg'};

/// Opens a file chooser and returns what the user picked.
typedef WeUploadPicker = Future<List<WeUploadFile>> Function(bool multiple);

/// Uploads [file], reporting 0–1 through [onProgress]. The returned value
/// becomes [WeUploadFile.response]; throwing marks the file failed.
typedef WeUploader =
    Future<Object?> Function(
      WeUploadFile file,
      ValueChanged<double> onProgress,
    );

/// Holds the files of a [WeUpload] and drives it from outside.
///
/// Use [addFiles] to feed files from elsewhere, such as a desktop drop
/// target, and [submit] to start uploads when `autoUpload` is off.
class WeUploadController extends ChangeNotifier {
  WeUploadController([List<WeUploadFile> files = const []])
    : _files = [...files];

  final List<WeUploadFile> _files;
  _WeUploadState? _state;

  List<WeUploadFile> get files => List.unmodifiable(_files);

  /// Checks and adds [files] as if the user had picked them.
  Future<void> addFiles(List<WeUploadFile> files) async {
    final state = _state;
    if (state != null) return state._add(files);
    _files.addAll(files);
    notifyListeners();
  }

  /// Uploads every file that is still [WeUploadStatus.ready].
  Future<void> submit() async => _state?._submit();

  /// Uploads a failed file again.
  Future<void> retry(WeUploadFile file) async => _state?._upload(file);

  /// Removes [file] without asking `beforeRemove`.
  void remove(WeUploadFile file) {
    if (_files.remove(file)) _changed();
  }

  void clear() {
    if (_files.isEmpty) return;
    _files.clear();
    _changed();
  }

  void _changed() {
    notifyListeners();
    _state?._reportChange();
  }

  void _tick() => notifyListeners();
}

/// A file uploader after `el-upload`, with no native dependency: the app
/// supplies [picker] (e.g. through `file_picker`) and [uploader] (e.g.
/// through `dio`), and the widget handles checks, the list, progress,
/// retries and removal.
///
/// ```dart
/// WeUpload(
///   picker: (multiple) async {
///     final r = await FilePicker.platform.pickFiles(allowMultiple: multiple, withData: true);
///     return [for (final f in r?.files ?? []) WeUploadFile(name: f.name, size: f.size, bytes: f.bytes)];
///   },
///   uploader: (file, onProgress) => api.upload(file.bytes!, onSendProgress: onProgress),
///   accept: const ['.png', '.jpg'],
///   maxSize: 2 * 1024 * 1024,
///   limit: 5,
///   listType: WeUploadListType.pictureCard,
/// )
/// ```
///
/// Inside a [WeFormItem] it takes the item's disabled state and reports
/// changes; pair it with `valueGetter: () => controller.files`.
class WeUpload extends StatefulWidget {
  const WeUpload({
    super.key,
    required this.picker,
    this.uploader,
    this.controller,
    this.multiple = false,
    this.accept = const [],
    this.maxSize,
    this.limit,
    this.autoUpload = true,
    this.listType = WeUploadListType.text,
    this.drag = false,
    this.showFileList = true,
    this.disabled = false,
    this.buttonText = '点击上传',
    this.dragText = '点击此处选择文件',
    this.tip,
    this.trigger,
    this.cardSize = 148,
    this.beforeUpload,
    this.beforeRemove,
    this.onExceed,
    this.onReject,
    this.onChanged,
    this.onSuccess,
    this.onError,
    this.onPreview,
  });

  final WeUploadPicker picker;

  /// `null` keeps files local: they are marked successful once added.
  final WeUploader? uploader;
  final WeUploadController? controller;
  final bool multiple;

  /// Allowed types: extensions (`.png` or `png`) or `image/*`. Empty allows
  /// everything.
  final List<String> accept;

  /// Largest file in bytes.
  final int? maxSize;

  /// Most files in the list. Picking past it calls [onExceed] and adds
  /// nothing.
  final int? limit;

  /// `false` keeps picked files ready until [WeUploadController.submit].
  final bool autoUpload;
  final WeUploadListType listType;

  /// A large dashed area instead of a button. Dropping files needs a drop
  /// target from the app that calls [WeUploadController.addFiles].
  final bool drag;
  final bool showFileList;
  final bool disabled;
  final String buttonText;
  final String dragText;

  /// A hint under the trigger, e.g. "jpg/png, 2 MB at most".
  final String? tip;

  /// Replaces the default button (not used by [WeUploadListType.pictureCard]).
  final Widget? trigger;

  /// Side of each card in [WeUploadListType.pictureCard].
  final double cardSize;

  /// Last check before a file is added; `false` drops it.
  final FutureOr<bool> Function(WeUploadFile file)? beforeUpload;

  /// Asked before a file is removed from the list; `false` keeps it.
  final FutureOr<bool> Function(WeUploadFile file)? beforeRemove;

  /// Picking would pass [limit]. Defaults to a warning message.
  final void Function(List<WeUploadFile> files)? onExceed;

  /// A file failed [accept] or [maxSize]. Defaults to a warning message.
  final void Function(WeUploadFile file, WeUploadReject reason)? onReject;

  /// The list changed: added, removed or finished.
  final ValueChanged<List<WeUploadFile>>? onChanged;
  final ValueChanged<WeUploadFile>? onSuccess;
  final ValueChanged<WeUploadFile>? onError;

  /// Tapping a file. Images default to a full-size preview.
  final ValueChanged<WeUploadFile>? onPreview;

  @override
  State<WeUpload> createState() => _WeUploadState();
}

class _WeUploadState extends State<WeUpload> {
  WeUploadController? _own;
  WeUploadController get _controller => widget.controller ?? _own!;
  WeFormItemState? _item;

  List<WeUploadFile> get _files => _controller._files;

  bool get _disabled => widget.disabled || (_item?.disabled ?? false);

  bool get _full => widget.limit != null && _files.length >= widget.limit!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _own = WeUploadController();
    _attach();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _item = WeFormItem.maybeOf(context);
  }

  @override
  void didUpdateWidget(WeUpload old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      final prev = old.controller ?? _own!;
      prev.removeListener(_rebuild);
      prev._state = null;
      if (widget.controller == null) {
        _own ??= WeUploadController(prev._files);
      }
      _attach();
    }
  }

  void _attach() {
    _controller._state = this;
    _controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    _controller.removeListener(_rebuild);
    _controller._state = null;
    _own?.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  void _reportChange() {
    widget.onChanged?.call(_controller.files);
    _item?.onChange();
  }

  Future<void> _pick() async {
    if (_disabled || _full) return;
    final picked = await widget.picker(widget.multiple);
    if (!mounted || picked.isEmpty) return;
    await _add(widget.multiple ? picked : picked.take(1).toList());
  }

  Future<void> _add(List<WeUploadFile> files) async {
    if (widget.limit != null && _files.length + files.length > widget.limit!) {
      if (widget.onExceed != null) {
        widget.onExceed!(files);
      } else {
        WeMessage.warning(context, '最多上传 ${widget.limit} 个文件');
      }
      return;
    }
    final accepted = <WeUploadFile>[];
    for (final f in files) {
      final WeUploadReject? reason = !_accepts(f)
          ? WeUploadReject.accept
          : widget.maxSize != null && (f.size ?? 0) > widget.maxSize!
          ? WeUploadReject.size
          : null;
      if (reason != null) {
        _reject(f, reason);
        continue;
      }
      if (widget.beforeUpload != null && !await widget.beforeUpload!(f)) {
        continue;
      }
      accepted.add(f);
    }
    if (!mounted || accepted.isEmpty) return;
    _files.addAll(accepted);
    _controller._changed();
    if (widget.autoUpload) {
      for (final f in accepted) {
        unawaited(_upload(f));
      }
    }
  }

  void _reject(WeUploadFile f, WeUploadReject reason) {
    if (widget.onReject != null) return widget.onReject!(f, reason);
    WeMessage.warning(
      context,
      reason == WeUploadReject.accept
          ? '不支持的文件类型：${f.name}'
          : '${f.name} 超过 ${weFormatBytes(widget.maxSize!)}',
    );
  }

  bool _accepts(WeUploadFile f) {
    if (widget.accept.isEmpty) return true;
    for (final raw in widget.accept) {
      final a = raw.trim().toLowerCase();
      if (a == 'image/*' && f.isImage) return true;
      if ((a.startsWith('.') ? a.substring(1) : a) == f.extension) return true;
    }
    return false;
  }

  Future<void> _submit() async {
    await Future.wait([
      for (final f in [..._files])
        if (f.status == WeUploadStatus.ready) _upload(f),
    ]);
  }

  Future<void> _upload(WeUploadFile f) async {
    final uploader = widget.uploader;
    f
      ..status = WeUploadStatus.uploading
      ..percentage = 0
      ..error = null;
    _controller._tick();
    try {
      final Object? response = uploader == null
          ? null
          : await uploader(f, (p) {
              if (f.status != WeUploadStatus.uploading) return;
              f.percentage = p.clamp(0.0, 1.0);
              _controller._tick();
            });
      if (!_files.contains(f)) return;
      f
        ..status = WeUploadStatus.success
        ..percentage = 1
        ..response = response;
      widget.onSuccess?.call(f);
    } catch (e) {
      if (!_files.contains(f)) return;
      f
        ..status = WeUploadStatus.fail
        ..error = e;
      widget.onError?.call(f);
    }
    if (mounted) _controller._changed();
  }

  Future<void> _remove(WeUploadFile f) async {
    if (_disabled) return;
    if (widget.beforeRemove != null && !await widget.beforeRemove!(f)) return;
    if (!mounted) return;
    f.status = WeUploadStatus.ready;
    _controller.remove(f);
  }

  void _preview(WeUploadFile f) {
    if (widget.onPreview != null) return widget.onPreview!(f);
    bool viewable(WeUploadFile x) =>
        x.isImage && (x.bytes != null || x.url != null);
    if (!viewable(f)) return;
    final gallery = _controller.files.where(viewable).toList();
    WeImageViewer.show(
      context,
      images: [
        for (final x in gallery)
          x.bytes != null
              ? WeImageSource.bytes(x.bytes!)
              : WeImageSource.network(x.url!),
      ],
      initialIndex: gallery.indexOf(f),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final Widget? tip = widget.tip == null
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              widget.tip!,
              style: TextStyle(fontSize: 12, color: colors.secondaryText),
            ),
          );

    if (widget.listType == WeUploadListType.pictureCard) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (widget.showFileList)
                for (final f in _files)
                  _Card(
                    key: ValueKey(f.uid),
                    file: f,
                    size: widget.cardSize,
                    disabled: _disabled,
                    onPreview: () => _preview(f),
                    onRemove: () => _remove(f),
                    onRetry: () => _upload(f),
                  ),
              if (!_full)
                _DashedTap(
                  disabled: _disabled,
                  onTap: _pick,
                  child: SizedBox.square(
                    dimension: widget.cardSize,
                    child: Icon(
                      Icons.add,
                      size: 28,
                      color: colors.secondaryText,
                    ),
                  ),
                ),
            ],
          ),
          ?tip,
        ],
      );
    }

    final Widget trigger = widget.drag
        ? _DashedTap(
            disabled: _disabled || _full,
            onTap: _pick,
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 56,
                    color: colors.placeholderText,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.dragText,
                    style: TextStyle(fontSize: 14, color: colors.regularText),
                  ),
                ],
              ),
            ),
          )
        : widget.trigger != null
        ? MouseRegion(
            cursor: _disabled || _full
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            child: GestureDetector(onTap: _pick, child: widget.trigger),
          )
        : WeButton(
            text: widget.buttonText,
            icon: Icons.upload_outlined,
            type: SemanticEnum.primary,
            size: _item?.size ?? SizeEnum.defaultSize,
            disabled: _disabled || _full,
            onPressed: _pick,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        trigger,
        ?tip,
        if (widget.showFileList && _files.isNotEmpty) ...[
          const SizedBox(height: 8),
          for (final f in _files)
            _Row(
              key: ValueKey(f.uid),
              file: f,
              picture: widget.listType == WeUploadListType.picture,
              disabled: _disabled,
              onPreview: () => _preview(f),
              onRemove: () => _remove(f),
              onRetry: () => _upload(f),
            ),
        ],
      ],
    );
  }
}

/// `1536` → `1.5 KB`.
String weFormatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  const units = ['KB', 'MB', 'GB'];
  double v = bytes / 1024;
  int i = 0;
  while (v >= 1024 && i < units.length - 1) {
    v /= 1024;
    i++;
  }
  final String s = v >= 10 || v == v.roundToDouble()
      ? v.toStringAsFixed(0)
      : v.toStringAsFixed(1);
  return '$s ${units[i]}';
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.file});

  final WeUploadFile file;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final Widget fallback = ColoredBox(
      color: colors.lightFill,
      child: Center(
        child: Icon(
          file.isImage ? Icons.image_outlined : Icons.description_outlined,
          color: colors.placeholderText,
        ),
      ),
    );
    if (file.isImage && file.bytes != null) {
      return Image.memory(
        file.bytes!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      );
    }
    if (file.isImage && file.url != null) {
      return Image.network(
        file.url!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      );
    }
    return fallback;
  }
}

class _Row extends StatefulWidget {
  const _Row({
    super.key,
    required this.file,
    required this.picture,
    required this.disabled,
    required this.onPreview,
    required this.onRemove,
    required this.onRetry,
  });

  final WeUploadFile file;
  final bool picture;
  final bool disabled;
  final VoidCallback onPreview;
  final VoidCallback onRemove;
  final VoidCallback onRetry;

  @override
  State<_Row> createState() => _RowState();
}

class _RowState extends State<_Row> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final f = widget.file;
    final bool failed = f.status == WeUploadStatus.fail;
    final Color nameColor = failed ? colors.danger : colors.regularText;

    Widget action(IconData icon, String tip, VoidCallback onTap, Color c) =>
        Tooltip(
          message: tip,
          child: InkResponse(
            onTap: onTap,
            radius: 14,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(icon, size: 16, color: c),
            ),
          ),
        );

    final Widget trailing = switch (f.status) {
      WeUploadStatus.uploading => Text(
        '${(f.percentage * 100).round()}%',
        style: TextStyle(fontSize: 12, color: colors.secondaryText),
      ),
      WeUploadStatus.success when !_hover || widget.disabled => Icon(
        Icons.check_circle_outline,
        size: 16,
        color: colors.success,
      ),
      _ => const SizedBox.shrink(),
    };

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        padding: EdgeInsets.symmetric(
          horizontal: widget.picture ? 10 : 6,
          vertical: widget.picture ? 10 : 4,
        ),
        decoration: BoxDecoration(
          color: _hover && !widget.picture ? colors.lightFill : null,
          borderRadius: BorderRadius.circular(4),
          border: widget.picture
              ? Border.all(color: failed ? colors.danger : colors.baseBorder)
              : null,
        ),
        child: Row(
          children: [
            if (widget.picture)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox.square(dimension: 56, child: _Thumb(file: f)),
              )
            else
              Icon(Icons.description_outlined, size: 16, color: nameColor),
            SizedBox(width: widget.picture ? 12 : 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: widget.onPreview,
                    child: Text(
                      f.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: _hover && !failed ? colors.primary : nameColor,
                      ),
                    ),
                  ),
                  if (f.status == WeUploadStatus.uploading)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: WeProgress(
                        percentage: f.percentage * 100,
                        showText: false,
                        strokeWidth: 2,
                      ),
                    )
                  else if (failed)
                    Text(
                      '上传失败',
                      style: TextStyle(fontSize: 12, color: colors.danger),
                    )
                  else if (widget.picture && f.size != null)
                    Text(
                      weFormatBytes(f.size!),
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.secondaryText,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing,
            if (failed && !widget.disabled)
              action(Icons.refresh, '重试', widget.onRetry, colors.primary),
            if (!widget.disabled &&
                (_hover || failed || f.status == WeUploadStatus.ready))
              action(Icons.close, '移除', widget.onRemove, colors.secondaryText),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatefulWidget {
  const _Card({
    super.key,
    required this.file,
    required this.size,
    required this.disabled,
    required this.onPreview,
    required this.onRemove,
    required this.onRetry,
  });

  final WeUploadFile file;
  final double size;
  final bool disabled;
  final VoidCallback onPreview;
  final VoidCallback onRemove;
  final VoidCallback onRetry;

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final f = widget.file;
    final bool failed = f.status == WeUploadStatus.fail;

    Widget button(IconData icon, String tip, VoidCallback onTap) => Tooltip(
      message: tip,
      child: InkResponse(
        onTap: onTap,
        radius: 16,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Container(
        width: widget.size,
        height: widget.size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.baseBackground,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: failed ? colors.danger : colors.baseBorder),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _Thumb(file: f),
            if (!f.isImage)
              Positioned(
                left: 6,
                right: 6,
                bottom: 6,
                child: Text(
                  f.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: colors.regularText),
                ),
              ),
            if (f.status == WeUploadStatus.uploading)
              ColoredBox(
                color: colors.baseBackground.withValues(alpha: 0.8),
                child: Center(
                  child: WeProgress(
                    percentage: f.percentage * 100,
                    type: WeProgressType.circle,
                    width: widget.size * 0.5,
                  ),
                ),
              ),
            if (f.status == WeUploadStatus.success)
              Positioned(
                right: -15,
                top: -6,
                child: Transform.rotate(
                  angle: 0.785,
                  child: Container(
                    width: 40,
                    height: 24,
                    alignment: Alignment.bottomCenter,
                    color: colors.success,
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (failed && !_hover)
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '上传失败',
                  style: TextStyle(fontSize: 12, color: colors.danger),
                ),
              ),
            if (_hover && f.status != WeUploadStatus.uploading)
              ColoredBox(
                color: Colors.black.withValues(alpha: 0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (f.isImage)
                      button(Icons.zoom_in, '预览', widget.onPreview),
                    if (failed && !widget.disabled)
                      button(Icons.refresh, '重试', widget.onRetry),
                    if (!widget.disabled)
                      button(Icons.delete_outline, '删除', widget.onRemove),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DashedTap extends StatefulWidget {
  const _DashedTap({
    required this.child,
    required this.onTap,
    required this.disabled,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool disabled;

  @override
  State<_DashedTap> createState() => _DashedTapState();
}

class _DashedTapState extends State<_DashedTap> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    return MouseRegion(
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.disabled ? null : widget.onTap,
        child: CustomPaint(
          painter: _DashedBorder(
            color: _hover && !widget.disabled
                ? colors.primary
                : colors.darkBorder,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: widget.disabled ? colors.lightFill : colors.lighterFill,
              borderRadius: BorderRadius.circular(6),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _DashedBorder extends CustomPainter {
  const _DashedBorder({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(6),
        ).deflate(0.5),
      );
    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 9) {
        canvas.drawPath(metric.extractPath(d, d + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorder old) => old.color != color;
}
