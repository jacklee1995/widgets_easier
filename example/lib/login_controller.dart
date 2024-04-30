import 'dart:async';

class LoginManager {
  Future<Map<String, dynamic>> simulateLogin(
      String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (username == 'jclee95' && password == '123456') {
      return {'status': true, 'message': '登录成功'};
    } else {
      return {'status': false, 'message': '账户名或密码错误'};
    }
  }
}
