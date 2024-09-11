

### 8. 弹窗

#### InfoDialogs

##### 弹窗构成

消息弹窗（InfoDialog）通常用于在移动应用中显示重要信息，需要用户明确地关闭弹窗以确保信息被看到。以下是InfoDialog的主要构成元素：

- 图标（可选）

- 标题（Title）
- 内容（Content）
- 关闭按钮（Close Button）

##### 使用语义

**InfoDialogs**是一种消息式的弹窗，这种弹窗只有一个按钮。你可以为**InfoDialogs**指定一个`type`属性，这将拥有语义性色彩。它的弹窗体看起来是这样的：

![example_nc62R6kkem](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_nc62R6kkem.png)

例如：

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    SemanticButton(
      text: 'primary弹窗',
      type: SemanticEnum.primary,
      isOutlined: true,
      onTap: () => InfoDialogs.show(
        context,
        title: "你好啊！",
        message: "这是一个primary消息弹窗",
        buttonText: "我知道了",
        onTapDismiss: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.primary,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'secondary弹窗',
      type: SemanticEnum.secondary,
      isOutlined: true,
      onTap: () => InfoDialogs.show(
        context,
        title: "你好啊！",
        message: "这是一个secondary消息弹窗",
        buttonText: "我知道了",
        onTapDismiss: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.secondary,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'info弹窗',
      type: SemanticEnum.info,
      isOutlined: true,
      onTap: () => InfoDialogs.show(
        context,
        title: "你好啊！",
        message: "这是一个info消息弹窗",
        buttonText: "我知道了",
        onTapDismiss: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.info,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'success弹窗',
      type: SemanticEnum.success,
      isOutlined: true,
      onTap: () => InfoDialogs.show(
        context,
        title: "你好啊！",
        message: "这是一个success消息弹窗",
        buttonText: "我知道了",
        onTapDismiss: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.success,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'warning弹窗',
      type: SemanticEnum.warning,
      isOutlined: true,
      onTap: () => InfoDialogs.show(
        context,
        title: "你好啊！",
        message: "这是一个warning消息弹窗",
        buttonText: "我知道了",
        onTapDismiss: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.warning,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'danger弹窗',
      type: SemanticEnum.danger,
      isOutlined: true,
      onTap: () => InfoDialogs.show(
        context,
        title: "你好啊！",
        message: "这是一个danger消息弹窗",
        buttonText: "我知道了",
        onTapDismiss: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.danger,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'fatal弹窗',
      type: SemanticEnum.fatal,
      isOutlined: true,
      onTap: () => InfoDialogs.show(
        context,
        title: "你好啊！",
        message: "这是一个fatal消息弹窗",
        buttonText: "我知道了",
        onTapDismiss: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.fatal,
      ),
    ),
  ],
)
```



![example_0YDNxnPzok](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_0YDNxnPzok.gif)



##### zoomIn动画

`InfoDialogs.show`是没有动画效果的。你可以直接使用`InfoDialogs.zoomIn`方法，这将有一个缩放效果的弹窗动画。`InfoDialogs.zoomIn`方法和`InfoDialogs.show`具体完全一样的参数。例如：



```dart
SemanticButton(
  text: 'zoomIn动画',
  shrink: true,
  onTap: () => InfoDialogs.zoomIn(
    context,
    title: "你好啊！",
    message: "这是一个fatal消息弹窗",
    buttonText: "我知道了",
    onTapDismiss: () {
      Navigator.of(context).pop();
    },
  ),
)
```

其效果如下：

![example_QCpD0oPAWg](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_QCpD0oPAWg.gif)



##### 自定义动画

你还可以通过在**InfoDialogs.showInfoDialog**方法中指定`transitionBuilder`参数来自定义弹窗动画效果，例如：

```dart
SemanticButton(
  text: '自定义动画',
  shrink: true,
  onTap: () => InfoDialogs.showInfoDialog(
    context,
    title: "你好啊！",
    message: "这是一个消息弹窗",
    buttonText: "我知道了",
    transitionBuilder:
        (context, animation, secondaryAnimation, child) {
      return AnimateStyles.backInDown(animation, child);
    },
    onTapDismiss: () {
      Navigator.of(context).pop();
    },
  ),
)
```

> 注：这里使用的`AnimateStyles.backInDown`动画需要单独安装：
>
> ```bash
> flutter pub add flutter_easy_animations
> ```

其效果如下：

![example_CYfwe0SU6B](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_CYfwe0SU6B.gif)



#### ConfirmDialogs

##### 弹窗构成

确认型弹窗（Confirmation Dialog）用于在执行某些可能具有重大影响的操作前，要求用户确认其决定。这种弹窗通常包含以下元素：

- 图标（可选）；

- 标题：简洁明了地描述所需确认的操作;
- 内容：提供操作的详细信息，帮助用户做出决策;
- 操作按钮：通常是“确认”和“取消”，有时可能包括其他选项，如“保存”，“不保存”等;

其消息窗体看起来是这样的：

![example_AR1n3S0R9d](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_AR1n3S0R9d.png)

##### 使用语义

你可以为**ConfirmDialogs**指定一个`type`属性，这将拥有语义性色彩。它的弹窗体看起来是这样的：

例如：

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    SemanticButton(
      text: 'primary弹窗',
      type: SemanticEnum.primary,
      onTap: () => ConfirmDialogs.show(
        context,
        title: "你确定吗",
        message: "这个是primary确认弹窗",
        confirmButtonText: "确定",
        cancelButtonText: "真的确定",
        onTapCancel: () {
          Navigator.of(context).pop();
        },
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.primary,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'secondary弹窗',
      type: SemanticEnum.secondary,
      onTap: () => ConfirmDialogs.show(
        context,
        title: "你确定吗",
        message: "这个是secondary确认弹窗",
        confirmButtonText: "确定",
        cancelButtonText: "真的确定",
        onTapCancel: () {
          Navigator.of(context).pop();
        },
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.secondary,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'info弹窗',
      type: SemanticEnum.info,
      onTap: () => ConfirmDialogs.show(
        context,
        title: "你确定吗",
        message: "这个是info确认弹窗",
        confirmButtonText: "确定",
        cancelButtonText: "真的确定",
        onTapCancel: () {
          Navigator.of(context).pop();
        },
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.info,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'success弹窗',
      type: SemanticEnum.success,
      onTap: () => ConfirmDialogs.show(
        context,
        title: "你确定吗",
        message: "这个是success确认弹窗",
        confirmButtonText: "确定",
        cancelButtonText: "真的确定",
        onTapCancel: () {
          Navigator.of(context).pop();
        },
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.success,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'warning弹窗',
      type: SemanticEnum.warning,
      onTap: () => ConfirmDialogs.show(
        context,
        title: "你确定吗",
        message: "这个是warning确认弹窗",
        confirmButtonText: "确定",
        cancelButtonText: "真的确定",
        onTapCancel: () {
          Navigator.of(context).pop();
        },
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.warning,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'danger弹窗',
      type: SemanticEnum.danger,
      onTap: () => ConfirmDialogs.show(
        context,
        title: "你确定吗",
        message: "这个是danger确认弹窗",
        confirmButtonText: "确定",
        cancelButtonText: "真的确定",
        onTapCancel: () {
          Navigator.of(context).pop();
        },
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.danger,
      ),
    ),
    const Gap(10),
    SemanticButton(
      text: 'fatal弹窗',
      type: SemanticEnum.fatal,
      onTap: () => ConfirmDialogs.show(
        context,
        title: "你确定吗",
        message: "这个是fatal确认弹窗",
        confirmButtonText: "确定",
        cancelButtonText: "真的确定",
        onTapCancel: () {
          Navigator.of(context).pop();
        },
        onTapConfirm: () {
          Navigator.of(context).pop();
        },
        type: SemanticEnum.fatal,
      ),
    ),
  ],
)
```



##### zoomIn动画

`ConfirmDialogs.show`是没有动画效果的。你可以直接使用`ConfirmDialogs.zoomIn`方法，这将有一个缩放效果的弹窗动画。`ConfirmDialogs.zoomIn`方法和`ConfirmDialogs.show`具体完全一样的参数。例如：



```dart
SemanticButton(
  text: 'zoomIn动画',
  shrink: true,
  onTap: () => ConfirmDialogs.zoomIn(
    context,
    title: "你确定吗",
    message: "这个是确认弹窗",
    confirmButtonText: "确定",
    cancelButtonText: "真的确定",
    onTapCancel: () {
      Navigator.of(context).pop();
    },
    onTapConfirm: () {
      Navigator.of(context).pop();
    },
  ),
)
```

其效果如下：

![example_UqL2qrRpiO](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_UqL2qrRpiO.gif)

##### 自定义动画

你还可以通过在**ConfirmDialogs.showInfoDialog**方法中指定`transitionBuilder`参数来自定义弹窗动画效果，例如：

```dart
SemanticButton(
  text: 'flipInX动画',
  shrink: true,
  onTap: () => ConfirmDialogs.showConfirmDialog(
    context,
    transitionBuilder:
        (context, animation, secondaryAnimation, child) {
      return AnimateStyles.flipInX(animation, child);
    },
    title: "你确定吗",
    message: "这个是确认弹窗",
    confirmButtonText: "确定",
    cancelButtonText: "真的确定",
    onTapCancel: () {
      Navigator.of(context).pop();
    },
    onTapConfirm: () {
      Navigator.of(context).pop();
    },
  ),
)
```

> 注：这里使用的`AnimateStyles.flipInX`动画需要单独安装：
>
> ```bash
> flutter pub add flutter_easy_animations
> ```

其效果如下：

![example_EGAUPCK3VF](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_EGAUPCK3VF.gif)


#### WinDialogs

WinDialogs是一种模仿Windows风格的弹窗。下面的示例展示了调用一个Windoiws风格的弹窗:

```dart
SemanticButton(
  text: '显示Windows风格弹窗',
  isOutlined: true,
  shrink: true,
  radius: 2,
  color: Colors.black,
  onTap: () => WinDialogs.show(
    context,
    title: 'title',
    icon: const Icon(Icons.run_circle_outlined),
    text: '在这个世界上，我们每个人都应该深刻理解，生活中，若能够不断地反思和自省，那么我们就能更好地理解生活的真谛。',
    contents: Row(
      children: [
        const Text('打开(O):'),
        const Gap(10),
        Expanded(
          child: Container(
            height: 25,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    ),
    actions: [
      SemanticButton(
        text: '确定',
        width: 90,
        isOutlined: true,
        radius: 2,
        color: Colors.black,
        onTap: () {},
      ),
      const Gap(10),
      SemanticButton(
        text: '取消',
        width: 90,
        isOutlined: true,
        radius: 2,
        color: Colors.black,
        onTap: () {},
      ),
      const Gap(10),
      SemanticButton(
        text: '浏览',
        width: 90,
        isOutlined: true,
        radius: 2,
        color: Colors.black,
        onTap: () {},
      ),
    ],
  ),
),
```

效果如图所示：

![example_Z45EJiFtKU](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_Z45EJiFtKU.gif)



与之前的弹窗一样，你可以使用`zoomIn`方法来设置一个从小到大的弹窗动画效果，该方法用于与`show`方法一样的参数：



![example_BTEipOt7f9](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_BTEipOt7f9.gif)



如果你打算自定义弹窗动画，这也是和之前的弹窗一样的。你可以使用`showWinDialog`，并通过`transitionBuilder`参数指定一个动画。例如：

```dart
SemanticButton(
  text: '使用bounceIn动画',
  isOutlined: true,
  shrink: true,
  radius: 2,
  color: Colors.black,
  onTap: () => WinDialogs.showWinDialog(
    context,
    transitionBuilder:
        (context, animation, secondaryAnimation, child) {
      return AnimateStyles.bounceIn(animation, child);
    },
    title: 'title',
    icon: const Icon(Icons.run_circle_outlined),
    text: '在这个世界上，我们每个人都应该深刻理解，生活中，若能够不断地反思和自省，那么我们就能更好地理解生活的真谛。',
    contents: Row(
      children: [
        const Text('打开(O):'),
        const Gap(10),
        Expanded(
          child: Container(
            height: 25,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    ),
    actions: [
      SemanticButton(
        text: '确定',
        width: 90,
        isOutlined: true,
        radius: 2,
        color: Colors.black,
        onTap: () {},
      ),
      const Gap(10),
      SemanticButton(
        text: '取消',
        width: 90,
        isOutlined: true,
        radius: 2,
        color: Colors.black,
        onTap: () {},
      ),
      const Gap(10),
      SemanticButton(
        text: '浏览',
        width: 90,
        isOutlined: true,
        radius: 2,
        color: Colors.black,
        onTap: () {},
      ),
    ],
  
```

其效果如下：

![example_XXgNIBMhxU](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/example_XXgNIBMhxU.gif)

> 注：这里使用的`AnimateStyles.bounceIn`动画需要单独安装：
>
> ```bash
> flutter pub add flutter_easy_animations
> ```





#### FutureDialogs

FutureDialogs 用于处理Future型弹窗。

一个 Future 对象在其生命周期中有两种状态：


1. **未完成（Uncompleted）**:

当 Future 被创建时，它处于未完成状态。这意味着异步操作尚未完成，结果还不可用。

2. **完成（Completed）**:

异步操作完成后，Future 进入完成状态。这个状态有两种可能的结果：

- **成功（Fulfilled）**: 异步操作成功完成，Future 获得了一个值。

- **失败（Rejected）**: 异步操作因错误而未能成功完成，Future 获得了一个错误。

FutureDialog弹窗中的静态方法需要对应构建加载中、成功、失败时候弹窗显示的内容。

以一个登录页面为例，登录请求需要请求后端服务器，有两种结果：成功、失败。于是我们分别构建下面两个弹窗的内容：

用于认证成功显示的内容：

```dart
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

class SuccessDialog extends StatelessWidget {
  final String data;
  const SuccessDialog(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 200,
          height: 200,
          margin: const EdgeInsets.all(26),
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check,
                color: Colors.green,
                size: 60,
              ),
              const Gap(20),
              Text(data, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
```

用于认证失败显示的内容：


```dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FailureDialog extends StatelessWidget {
  final String data;
  const FailureDialog(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 230,
          height: 200,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.close,
                color: Colors.red,
                size: 60,
              ),
              const Gap(20),
              Text(data,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
```

然后我们在登录页面中调用弹窗：


```dart
import 'package:example/login/dialogs/failure_dialog.dart';
import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';

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
    FutureDialogs.show<String>(
      context: context,
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
```

其中：

```dart
FutureDialogs.show<String>(
      context: context,
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
```

可以我们在完成完成之后还可以链式执行一些操作。这种设计非常有必要，以此例子为例，在登录成功之后我们跳转到了登录成功页面。其中这里then的参数result也是futureCallback返回的值。另一方面，如果有需要也可以在这里继续下一个弹窗。

其中异步函数：


```dart
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

```

在这段代码中，simulateLogin是一个模拟异步登录的函数。
如果登录成功，则返回：

```dart
{'status': true, 'data': '登录成功'}
```

如果登录失败则返回：

```dart
{'status': false, 'data': '账户名或密码错误'}
```


然后构建一个登录成功页面



```dart
import 'package:flutter/material.dart';

class LoginSuccessView extends StatelessWidget {
  const LoginSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录成功'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '您已成功登录！',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('回到主页'),
            ),
          ],
        ),
      ),
    );
  }
}
```

看起来效果是这样的：



1.用户名密码为空：
![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/989b2405eaab4d629d9ce22c4a9a6a71.gif)



2. 输入错误的密码：

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/9fc16728e2c740e39d3bd1f729a6dd7d.gif)

3. 密码认证成功

![在这里插入图片描述](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/296cf1829bb047448477db75ff560ed1.gif)