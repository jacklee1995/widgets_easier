import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier_privacy_guard/widgets_easier_privacy_guard.dart';

const MethodChannel _channel = MethodChannel(
  'tech.thispage.widgets_easier_privacy_guard',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late List<MethodCall> calls;

  setUp(() {
    PrivacyGuardPlatform.debugReset();
    calls = [];
    messenger.setMockMethodCallHandler(_channel, (call) async {
      calls.add(call);
      if (call.method == 'getCapabilities') {
        return {'preventScreenshot': true, 'screenshotDetection': true};
      }
      return null;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(_channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test('holds are reference counted', () {
    final a = PrivacyGuardPlatform.requestSecure();
    final b = PrivacyGuardPlatform.requestSecure();
    a.release();
    a.release();
    expect(calls.map((c) => c.arguments), [true]);
    b.release();
    expect(calls.map((c) => '${c.method}:${c.arguments}'), [
      'setSecure:true',
      'setSecure:false',
    ]);
    expect(a.isActive, isFalse);
  });

  test('setSecure shares the counter with widget holds', () {
    final widgetHold = PrivacyGuardPlatform.requestSecure();
    PrivacyGuardPlatform.setSecure(true);
    PrivacyGuardPlatform.setSecure(true);
    PrivacyGuardPlatform.setSecure(false);
    expect(calls.map((c) => c.arguments), [true]);
    widgetHold.release();
    expect(calls.map((c) => c.arguments), [true, false]);
  });

  test('platform-specific flags stay off the channel elsewhere', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    PrivacyGuardPlatform.requestIosSecureLayer().release();
    PrivacyGuardPlatform.requestHideInRecents().release();
    expect(calls.map((c) => '${c.method}:${c.arguments}'), [
      'setHideInRecents:true',
      'setHideInRecents:false',
    ]);
  });

  test('platforms without a native side never touch the channel', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    expect(PrivacyGuardPlatform.isSecureSupported, isFalse);
    PrivacyGuardPlatform.requestSecure().release();
    expect(
      await PrivacyGuardPlatform.getCapabilities(),
      PrivacyGuardCapabilities.none,
    );
    expect(calls, isEmpty);
  });

  test('reads capabilities from the platform', () async {
    final caps = await PrivacyGuardPlatform.getCapabilities();
    expect(caps.preventScreenshot, isTrue);
    expect(caps.screenshotDetection, isTrue);
    expect(caps.recordingDetection, isFalse);
  });

  test('a platform error is reported instead of thrown', () async {
    messenger.setMockMethodCallHandler(_channel, (call) async {
      throw PlatformException(code: 'boom');
    });
    final errors = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = errors.add;
    addTearDown(() => FlutterError.onError = previous);

    expect(
      await PrivacyGuardPlatform.getCapabilities(),
      PrivacyGuardCapabilities.none,
    );
    expect(errors.single.exception, isA<PlatformException>());
  });
}
