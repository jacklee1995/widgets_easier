import 'package:flutter/material.dart';

import 'home_view.dart';
import 'theme_mode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeMode,
      builder: (context, value, child) => MaterialApp(
        title: 'Widgets Easier Demo',
        themeMode: value,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: const HomeView(title: 'Demos'),
      ),
    );
  }
}
