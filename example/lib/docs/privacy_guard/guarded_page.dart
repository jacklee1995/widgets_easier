import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';

class GuardedPage extends StatelessWidget {
  const GuardedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PrivacyGuard(
      preventScreenshot: true,
      onEnterPrivacyMode: () => print('onEnterPrivacyMode'),
      onExitPrivacyMode: () => print('onExitPrivacyMode'),
      onScreenshot: () => TipToasts.toCenter(context, '禁止截屏'),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('登录页面'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '守卫登录页',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: '账户',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: '密码',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // 登录逻辑
                    },
                    child: const Text('登录'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
