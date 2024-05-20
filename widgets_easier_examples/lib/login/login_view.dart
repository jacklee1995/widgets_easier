import 'package:flutter/material.dart';
import 'package:flutter_easy_animations/flutter_easy_animations.dart';
import 'package:widgets_easier/widgets_easier.dart';

import 'dialogs/failure_dialog.dart';
import 'dialogs/success_dialog.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginController loginManager = LoginController();

  void handleLogin(BuildContext context) {
    // 从文本控制器获取用户名和密码
    final String username = usernameController.text;
    final String password = passwordController.text;

    // 显示一个异步操作的对话框，这个对话框将在 simulateLogin 方法的 Future 完成后关闭
    FutureDialogs.showFutureDialog(
      context: context,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return AnimateStyles.rollIn(animation, child);
      },
      futureCallback: () => loginManager.simulateLogin(username, password),
      buildSuccessDialog: (data) {
        return SuccessDialog(data);
      },
      buildFailureDialog: (data) {
        return FailureDialog(data);
      },
    ).then((result) {
      // 检查从 simulateLogin 返回的结果
      if (result != null && result['status'] == true) {
        // 如果登录成功，导航到主页
        Navigator.pushReplacementNamed(context, '/login-success');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FutureDialogs 示例')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: '输入你的账号',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_circle),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: '输入你的密码',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SemanticButton(
              text: '登录',
              type: SemanticEnum.primary,
              onTap: () => handleLogin(context),
              radius: 40,
              isOutlined: true,
            )
          ],
        ),
      ),
    );
  }
}
