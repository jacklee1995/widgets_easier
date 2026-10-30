import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [WeTheme.light()]),
  home: Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: child,
    ),
  ),
);

WeUploadPicker _pickerOf(List<WeUploadFile> Function() files) =>
    (multiple) async => files();

void main() {
  testWidgets('选中文件后上传：进度百分比 → 成功', (tester) async {
    final progress = StreamController<double>();
    final done = Completer<Object?>();
    WeUploadFile? succeeded;
    await tester.pumpWidget(
      _app(
        WeUpload(
          picker: _pickerOf(() => [WeUploadFile(name: 'a.txt', size: 10)]),
          uploader: (file, onProgress) {
            progress.stream.listen(onProgress);
            return done.future;
          },
          onSuccess: (f) => succeeded = f,
        ),
      ),
    );

    await tester.tap(find.text('点击上传'));
    await tester.pump();
    expect(find.text('a.txt'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);

    progress.add(0.4);
    await tester.pump();
    expect(find.text('40%'), findsOneWidget);

    done.complete('ok');
    await tester.pump();
    expect(succeeded?.response, 'ok');
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    await progress.close();
  });

  testWidgets('上传失败显示失败并可重试', (tester) async {
    int calls = 0;
    await tester.pumpWidget(
      _app(
        WeUpload(
          picker: _pickerOf(() => [WeUploadFile(name: 'b.txt')]),
          uploader: (file, onProgress) async {
            calls++;
            if (calls == 1) throw Exception('boom');
            return null;
          },
        ),
      ),
    );

    await tester.tap(find.text('点击上传'));
    await tester.pump();
    await tester.pump();
    expect(find.text('上传失败'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();
    await tester.pump();
    expect(calls, 2);
    expect(find.text('上传失败'), findsNothing);
  });

  testWidgets('accept 与 maxSize 不合格的文件被拒绝', (tester) async {
    final rejected = <String, WeUploadReject>{};
    final controller = WeUploadController();
    await tester.pumpWidget(
      _app(
        WeUpload(
          controller: controller,
          multiple: true,
          accept: const ['.png', 'jpg'],
          maxSize: 100,
          picker: _pickerOf(
            () => [
              WeUploadFile(name: 'ok.PNG', size: 50),
              WeUploadFile(name: 'doc.pdf', size: 50),
              WeUploadFile(name: 'big.jpg', size: 500),
            ],
          ),
          onReject: (f, r) => rejected[f.name] = r,
        ),
      ),
    );

    await tester.tap(find.text('点击上传'));
    await tester.pump();
    await tester.pump();
    expect(controller.files.map((f) => f.name), ['ok.PNG']);
    expect(rejected, {
      'doc.pdf': WeUploadReject.accept,
      'big.jpg': WeUploadReject.size,
    });
  });

  testWidgets('超过 limit 时调用 onExceed，一个也不加；满了禁用按钮', (tester) async {
    List<WeUploadFile>? exceeded;
    final controller = WeUploadController([
      WeUploadFile.uploaded(name: 'old.txt'),
    ]);
    await tester.pumpWidget(
      _app(
        WeUpload(
          controller: controller,
          multiple: true,
          limit: 2,
          picker: _pickerOf(
            () => [WeUploadFile(name: 'x'), WeUploadFile(name: 'y')],
          ),
          onExceed: (f) => exceeded = f,
        ),
      ),
    );

    await tester.tap(find.text('点击上传'));
    await tester.pump();
    expect(exceeded, hasLength(2));
    expect(controller.files, hasLength(1));

    await controller.addFiles([WeUploadFile(name: 'z.txt')]);
    await tester.pump();
    expect(controller.files, hasLength(2));
    expect(tester.widget<WeButton>(find.byType(WeButton)).disabled, isTrue);
  });

  testWidgets('beforeRemove 返回 false 时保留文件', (tester) async {
    bool allow = false;
    final controller = WeUploadController([
      WeUploadFile.uploaded(name: 'keep.txt'),
    ]);
    await tester.pumpWidget(
      _app(
        WeUpload(
          controller: controller,
          picker: _pickerOf(() => []),
          beforeRemove: (f) => allow,
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: tester.getCenter(find.text('keep.txt')));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    expect(controller.files, hasLength(1));

    allow = true;
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    expect(controller.files, isEmpty);
    await gesture.removePointer();
  });

  testWidgets('autoUpload: false 时等 submit 再传', (tester) async {
    final uploaded = <String>[];
    final controller = WeUploadController();
    await tester.pumpWidget(
      _app(
        WeUpload(
          controller: controller,
          autoUpload: false,
          picker: _pickerOf(() => [WeUploadFile(name: 'later.txt')]),
          uploader: (f, _) async => uploaded.add(f.name),
        ),
      ),
    );

    await tester.tap(find.text('点击上传'));
    await tester.pump();
    expect(controller.files.single.status, WeUploadStatus.ready);
    expect(uploaded, isEmpty);

    await controller.submit();
    await tester.pump();
    expect(uploaded, ['later.txt']);
    expect(controller.files.single.status, WeUploadStatus.success);
  });

  testWidgets('图片墙：满额后隐藏加号卡片', (tester) async {
    final controller = WeUploadController();
    await tester.pumpWidget(
      _app(
        WeUpload(
          controller: controller,
          limit: 1,
          listType: WeUploadListType.pictureCard,
          picker: _pickerOf(() => [WeUploadFile(name: 'p.png')]),
        ),
      ),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.pump();
    expect(controller.files.single.status, WeUploadStatus.success);
    expect(find.byIcon(Icons.add), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('在 WeFormItem 里：必填校验随上传清除', (tester) async {
    final form = WeFormController();
    final controller = WeUploadController();
    await tester.pumpWidget(
      _app(
        WeForm(
          controller: form,
          children: [
            WeFormItem(
              name: 'files',
              label: '附件',
              valueGetter: () => controller.files,
              rules: const [WeRule(required: true, message: '请上传附件')],
              child: WeUpload(
                controller: controller,
                picker: _pickerOf(() => [WeUploadFile(name: 'f.txt')]),
              ),
            ),
          ],
        ),
      ),
    );

    expect(await form.validate(), isFalse);
    await tester.pump();
    expect(find.text('请上传附件'), findsOneWidget);

    await tester.tap(find.text('点击上传'));
    await tester.pump();
    await tester.pump();
    await tester.pump();
    expect(find.text('请上传附件'), findsNothing);
  });

  test('weFormatBytes', () {
    expect(weFormatBytes(512), '512 B');
    expect(weFormatBytes(1536), '1.5 KB');
    expect(weFormatBytes(2 * 1024 * 1024), '2 MB');
  });
}
