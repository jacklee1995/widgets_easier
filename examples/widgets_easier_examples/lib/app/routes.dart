import 'package:flutter/material.dart';

import '../home_view.dart';
import '../login/login_success_view.dart';
import '../login/login_view.dart';

final Map<String, WidgetBuilder> routes = {
  '/home': (context) => const HomeView(),
  '/login': (context) => const LoginPage(),
  '/login-success': (context) => const LoginSuccessView()
};
