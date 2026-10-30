import 'package:flutter/material.dart';
import 'package:widgets_easier_privacy_guard/widgets_easier_privacy_guard.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: SecretPage());
}

class SecretPage extends StatefulWidget {
  const SecretPage({super.key});

  @override
  State<SecretPage> createState() => _SecretPageState();
}

class _SecretPageState extends State<SecretPage> {
  bool _enabled = true;
  bool _preventScreenshot = true;
  bool _hideInRecents = false;
  bool _blurWhenInactive = true;
  bool _blurWhileRecording = true;
  bool _iosSecureLayerHack = false;
  bool _customOverlay = false;
  final List<String> _log = [];
  late final Future<PrivacyGuardCapabilities> _capabilities =
      PrivacyGuardPlatform.getCapabilities();

  void _record(String message) {
    final time = TimeOfDay.now().format(context);
    setState(() => _log.insert(0, '$time  $message'));
  }

  @override
  Widget build(BuildContext context) {
    // The blur appears as soon as the app leaves the foreground, so it also
    // covers the task switcher preview.
    return PrivacyGuard(
      enabled: _enabled,
      preventScreenshot: _preventScreenshot,
      hideInRecents: _hideInRecents,
      blurWhenInactive: _blurWhenInactive,
      blurWhileRecording: _blurWhileRecording,
      iosSecureLayerHack: _iosSecureLayerHack,
      overlayBuilder: _customOverlay ? _lockScreen : null,
      onEnterPrivacyMode: () => _record('overlay shown'),
      onExitPrivacyMode: () => _record('overlay hidden'),
      onScreenshot: () => _record('screenshot taken'),
      onScreenRecordingChanged: (on) =>
          _record(on ? 'recording started' : 'recording stopped'),
      child: Scaffold(
        appBar: AppBar(title: const Text('Privacy Guard')),
        body: ListView(
          children: [
            const ListTile(
              title: Text('4111 1111 1111 1111'),
              subtitle: Text('Pretend this is a card number'),
            ),
            const Divider(),
            _switch('Enabled', _enabled, (v) => _enabled = v),
            _switch(
              'Block screenshots',
              _preventScreenshot,
              (v) => _preventScreenshot = v,
            ),
            _switch(
              'Hide in recents only (Android 13+)',
              _hideInRecents,
              (v) => _hideInRecents = v,
            ),
            _switch(
              'Blur when inactive',
              _blurWhenInactive,
              (v) => _blurWhenInactive = v,
            ),
            _switch(
              'Blur while recording',
              _blurWhileRecording,
              (v) => _blurWhileRecording = v,
            ),
            _switch(
              'iOS secure-layer workaround',
              _iosSecureLayerHack,
              (v) => _iosSecureLayerHack = v,
            ),
            _switch(
              'Custom overlay',
              _customOverlay,
              (v) => _customOverlay = v,
            ),
            const Divider(),
            _CapabilitiesTile(_capabilities),
            const Divider(),
            const ListTile(title: Text('Events')),
            for (final line in _log) ListTile(dense: true, title: Text(line)),
          ],
        ),
      ),
    );
  }

  Widget _switch(String title, bool value, void Function(bool) update) =>
      SwitchListTile(
        title: Text(title),
        value: value,
        onChanged: (v) => setState(() => update(v)),
      );

  Widget _lockScreen(BuildContext context) => const ColoredBox(
    color: Colors.indigo,
    child: Center(child: Icon(Icons.lock, size: 64, color: Colors.white)),
  );
}

class _CapabilitiesTile extends StatelessWidget {
  const _CapabilitiesTile(this.capabilities);

  final Future<PrivacyGuardCapabilities> capabilities;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: capabilities,
      builder: (context, snapshot) {
        final caps = snapshot.data;
        if (caps == null) return const ListTile(title: Text('Checking...'));
        String mark(bool supported) => supported ? 'yes' : 'no';
        return ListTile(
          title: const Text('This device supports'),
          subtitle: Text(
            'Block screenshots: ${mark(caps.preventScreenshot)}\n'
            'Hide in recents: ${mark(caps.hideInRecents)}\n'
            'Screenshot events: ${mark(caps.screenshotDetection)}\n'
            'Recording events: ${mark(caps.recordingDetection)}\n'
            'iOS secure layer: ${mark(caps.iosSecureLayer)}',
          ),
        );
      },
    );
  }
}
