import 'package:flutter/material.dart';

// 创建一个 ValueNotifier 用于管理主题模式
ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);
