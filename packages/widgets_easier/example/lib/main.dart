import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widgets Easier example',
      // The only setup step: install WeTheme on the ThemeData you already
      // have. Skip it and the components fall back to a palette matching
      // ThemeData.brightness.
      theme: ThemeData.light().copyWith(extensions: const [WeTheme.light()]),
      darkTheme: ThemeData.dark().copyWith(extensions: const [WeTheme.dark()]),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widgets Easier')),
      body: SafeArea(child: [const FormDemo(), const BasicsDemo()][_tab]),
      // A phone-style tab bar; on desktop you would reach for WeMenu.
      bottomNavigationBar: WeTabbar(
        index: _tab,
        onChanged: (i) => setState(() => _tab = i),
        items: const [
          WeTabbarItem('Form', Icons.edit_note_outlined),
          WeTabbarItem('Basics', Icons.widgets_outlined, dot: true),
        ],
      ),
    );
  }
}

class FormDemo extends StatefulWidget {
  const FormDemo({super.key});

  @override
  State<FormDemo> createState() => _FormDemoState();
}

class _FormDemoState extends State<FormDemo> {
  String _name = '';
  String? _city = 'hz';
  DateTime? _date = DateTime.now();
  bool _notify = true;

  Future<void> _submit() async {
    final bool ok = await WeMessageBox.confirm(
      context,
      'Book a visit for ${_name.isEmpty ? 'a guest' : _name}?',
      title: 'Confirm',
      confirmText: 'Book',
      cancelText: 'Cancel',
    );
    if (ok && mounted) WeMessage.success(context, 'Booked!');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        WeInput(
          hint: 'Your name',
          prefixIcon: Icons.person_outline,
          clearable: true,
          onChanged: (v) => setState(() => _name = v),
        ),
        const SizedBox(height: 12),
        WeSelect<String>(
          value: _city,
          hint: 'City',
          onChanged: (v) => setState(() => _city = v),
          options: const [
            WeSelectOption('hz', 'Hangzhou'),
            WeSelectOption('sh', 'Shanghai'),
            WeSelectOption('bj', 'Beijing'),
          ],
        ),
        const SizedBox(height: 12),
        // A calendar panel on desktop, a bottom-sheet wheel on phones.
        WeDatePicker(
          value: _date,
          locale: WeDateLocale.en,
          onChanged: (d) => setState(() => _date = d),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            WeSwitch(
              value: _notify,
              onChanged: (v) => setState(() => _notify = v),
            ),
            const SizedBox(width: 8),
            const Expanded(child: Text('Remind me the day before')),
          ],
        ),
        const SizedBox(height: 20),
        WeButton(
          text: 'Book a visit',
          type: SemanticEnum.primary,
          onPressed: _submit,
        ),
      ],
    );
  }
}

class BasicsDemo extends StatelessWidget {
  const BasicsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const WeAlert(
          title: 'Every component reads its colours from WeTheme.',
          type: SemanticEnum.success,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            for (final type in SemanticEnum.values)
              Tag(type.name, type: type, theme: TagThemeEnum.light),
          ],
        ),
        const SizedBox(height: 24),
        const Center(
          child: DecoratedBox(
            decoration: ShapeDecoration(shape: OutsetBorder(width: 8)),
            child: SizedBox(width: 220, height: 80),
          ),
        ),
      ],
    );
  }
}
