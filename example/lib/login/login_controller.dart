import 'dart:async';

class LoginController {
  Future<Map<String, dynamic>> simulateLogin(
    String username,
    String password,
  ) async {
    // 一般对于空密码等情况可以在客户端验证，以减少API请求
    if (username.isEmpty || password.isEmpty) {
      return {
        'status': false,
        'data': '账户名或密码不能为空',
      };
    }
    // 模拟请求API返回结果，有可能成功也有可能失败
    else if (username == 'jclee95' && password == '123456') {
      await Future.delayed(const Duration(seconds: 1));
      return {'status': true, 'data': '登录成功'};
    } else {
      await Future.delayed(const Duration(seconds: 1));
      return {'status': false, 'data': '账户名或密码错误'};
    }
  }
}
