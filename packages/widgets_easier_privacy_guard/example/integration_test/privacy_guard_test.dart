// Runs against the real platform side:
//   flutter test integration_test -d <device>
//
// What can be checked automatically is that every call reaches the native
// code and comes back without an error. Whether a screenshot really comes out
// black, or whether taking one fires onScreenshot, still needs a person with
// the device in hand; see the checklist in the package README.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:widgets_easier_privacy_guard/widgets_easier_privacy_guard.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final errors = <FlutterErrorDetails>[];
  late FlutterExceptionHandler? previous;

  setUp(() {
    errors.clear();
    previous = FlutterError.onError;
    FlutterError.onError = errors.add;
  });

  tearDown(() => FlutterError.onError = previous);

  testWidgets('capabilities match the platform', (tester) async {
    final caps = await PrivacyGuardPlatform.getCapabilities();
    expect(caps.preventScreenshot, PrivacyGuardPlatform.isSecureSupported);
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      expect(caps.screenshotDetection, isTrue);
      expect(caps.recordingDetection, isTrue);
    }
  });

  testWidgets('every flag round-trips without a platform error', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PrivacyGuard(
          preventScreenshot: true,
          hideInRecents: true,
          onScreenshot: () {},
          onScreenRecordingChanged: (_) {},
          child: const Text('secret'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pumpWidget(const MaterialApp(home: Text('gone')));
    await tester.pumpAndSettle();
    expect(errors, isEmpty);
  });

  testWidgets('recording state is reported once listened to', (tester) async {
    final caps = await PrivacyGuardPlatform.getCapabilities();
    if (!caps.recordingDetection) return;
    final first = await PrivacyGuardPlatform.onScreenRecordingChanged.first
        .timeout(const Duration(seconds: 5));
    expect(first, isFalse);
  });
}
