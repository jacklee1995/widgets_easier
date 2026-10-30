import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier_privacy_guard/widgets_easier_privacy_guard.dart';

const MethodChannel _channel = MethodChannel(
  'tech.thispage.widgets_easier_privacy_guard',
);
const EventChannel _events = EventChannel(
  'tech.thispage.widgets_easier_privacy_guard/events',
);

// flutter_test reports Android as the target platform, so channel calls go
// out without an override. Overriding inside a testWidgets body would trip
// debugAssertAllFoundationVarsUnset.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late List<MethodCall> calls;
  MockStreamHandlerEventSink? sink;

  setUp(() {
    PrivacyGuardPlatform.debugReset();
    calls = [];
    sink = null;
    messenger.setMockMethodCallHandler(_channel, (call) async {
      calls.add(call);
      return null;
    });
    messenger.setMockStreamHandler(
      _events,
      MockStreamHandler.inline(
        onListen: (_, events) {
          sink = events;
        },
      ),
    );
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(_channel, null);
    messenger.setMockStreamHandler(_events, null);
  });

  Future<void> lifecycle(WidgetTester tester, AppLifecycleState state) async {
    tester.binding.handleAppLifecycleStateChanged(state);
    await tester.pump();
  }

  Future<void> background(WidgetTester tester) async {
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ]) {
      await lifecycle(tester, state);
    }
  }

  Iterable<String> secureCalls() => calls
      .where((c) => c.method == 'setSecure')
      .map((c) => '${c.arguments}');

  testWidgets('applies the flag on mount and clears it on dispose', (
    tester,
  ) async {
    await tester.pumpWidget(
      const PrivacyGuard(preventScreenshot: true, child: SizedBox()),
    );
    expect(secureCalls(), ['true']);
    await tester.pumpWidget(const SizedBox());
    expect(secureCalls(), ['true', 'false']);
  });

  testWidgets('two guards share the flag', (tester) async {
    Widget guards(int count) => Column(
      textDirection: TextDirection.ltr,
      children: [
        for (var i = 0; i < count; i++)
          const PrivacyGuard(preventScreenshot: true, child: SizedBox()),
      ],
    );
    await tester.pumpWidget(guards(2));
    await tester.pumpWidget(guards(1));
    expect(secureCalls(), ['true']);
    await tester.pumpWidget(guards(0));
    expect(secureCalls(), ['true', 'false']);
  });

  testWidgets('re-sends the flag when it changes and on enabled', (
    tester,
  ) async {
    Widget guard({required bool prevent, bool enabled = true}) => PrivacyGuard(
      enabled: enabled,
      preventScreenshot: prevent,
      child: const SizedBox(),
    );
    await tester.pumpWidget(guard(prevent: false));
    await tester.pumpWidget(guard(prevent: true));
    await tester.pumpWidget(guard(prevent: true, enabled: false));
    expect(secureCalls(), ['true', 'false']);
  });

  group('overlay', () {
    tearDown(() {
      TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(
        AppLifecycleState.resumed,
      );
    });

    testWidgets('callbacks fire once per transition', (tester) async {
      var entered = 0, exited = 0;
      await tester.pumpWidget(
        PrivacyGuard(
          onEnterPrivacyMode: () => entered++,
          onExitPrivacyMode: () => exited++,
          child: const SizedBox(),
        ),
      );
      await background(tester);
      expect(find.byType(BackdropFilter), findsOneWidget);
      expect((entered, exited), (1, 0));

      await lifecycle(tester, AppLifecycleState.hidden);
      await lifecycle(tester, AppLifecycleState.inactive);
      await lifecycle(tester, AppLifecycleState.resumed);
      expect(find.byType(BackdropFilter), findsNothing);
      expect((entered, exited), (1, 1));
    });

    testWidgets('hidden blurs, inactive can be opted out', (tester) async {
      await tester.pumpWidget(
        const PrivacyGuard(blurWhenInactive: false, child: SizedBox()),
      );
      await lifecycle(tester, AppLifecycleState.inactive);
      expect(find.byType(BackdropFilter), findsNothing);
      await lifecycle(tester, AppLifecycleState.hidden);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('blur is clipped and the child is shielded', (tester) async {
      final handle = tester.ensureSemantics();
      var taps = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: PrivacyGuard(
            child: TextButton(onPressed: () => taps++, child: const Text('x')),
          ),
        ),
      );
      await lifecycle(tester, AppLifecycleState.inactive);
      expect(
        find.ancestor(
          of: find.byType(BackdropFilter),
          matching: find.byType(ClipRect),
        ),
        findsWidgets,
      );
      expect(find.semantics.byLabel('x'), findsNothing);
      await tester.tap(find.text('x'), warnIfMissed: false);
      expect(taps, 0);
      handle.dispose();
    });

    testWidgets('overlayBuilder replaces the blur', (tester) async {
      await tester.pumpWidget(
        PrivacyGuard(
          overlayBuilder: (_) => const Placeholder(),
          child: const SizedBox(),
        ),
      );
      await background(tester);
      expect(find.byType(Placeholder), findsOneWidget);
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('disabled guards never show the overlay', (tester) async {
      await tester.pumpWidget(
        const PrivacyGuard(enabled: false, child: SizedBox()),
      );
      await background(tester);
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('capture events reach the callbacks', (tester) async {
      // Platform messages are delivered on the real event loop, outside the
      // fake async zone testWidgets runs in.
      Future<void> send(Map<String, Object> event) async {
        await tester.runAsync(() async {
          sink!.success(event);
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pump();
      }

      var shots = 0;
      final recording = <bool>[];
      await tester.pumpWidget(
        PrivacyGuard(
          blurWhileRecording: true,
          onScreenshot: () => shots++,
          onScreenRecordingChanged: recording.add,
          child: const SizedBox(),
        ),
      );
      await send({'type': 'screenshot'});
      await send({'type': 'recording', 'active': true});
      expect(shots, 1);
      expect(recording, [true]);
      expect(find.byType(BackdropFilter), findsOneWidget);

      await send({'type': 'recording', 'active': false});
      expect(recording, [true, false]);
      expect(find.byType(BackdropFilter), findsNothing);
    });
  });
}
