import 'package:flutter/material.dart';

// 显示验证过程和结果的对话框。
class VerificationDialog extends StatefulWidget {
  final Future<Map<String, dynamic>> Function() verificationFunction;

  const VerificationDialog({
    Key? key,
    required this.verificationFunction,
  }) : super(key: key);

  @override
  State<VerificationDialog> createState() => _VerificationDialogState();
}

class _VerificationDialogState extends State<VerificationDialog> {
  late Future<Map<String, dynamic>> _futureResult;

  @override
  void initState() {
    super.initState();
    // 在initState中调用verificationFunction并将结果赋值给_futureResult，以便FutureBuilder使用。
    _futureResult = widget.verificationFunction();
  }

  @override
  Widget build(BuildContext context) {
    // 使用FutureBuilder来根据_futureResult的状态构建UI。
    return FutureBuilder<Map<String, dynamic>>(
      future: _futureResult,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // 如果Future已完成，根据结果显示对应的图标和消息。
          // 延迟1秒后关闭弹窗，并返回结果给上一个页面。
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop(snapshot.data);
          });

          // 根据验证结果的状态显示对应的图标。
          Widget content = snapshot.data?['status'] ?? false
              ? const Icon(Icons.check, color: Colors.green) // 验证成功显示绿色对勾图标。
              : const Icon(Icons.close, color: Colors.red); // 验证失败显示红色关闭图标。
          // 获取验证结果的消息文本。
          String message = snapshot.data?['message'] ?? '';

          // 构建显示结果的对话框。
          return Dialog(
            backgroundColor: Colors.black.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  content, // 显示验证结果图标。
                  const SizedBox(height: 10), // 添加间隔。
                  Text(message,
                      style: const TextStyle(color: Colors.white)), // 显示验证消息。
                ],
              ),
            ),
          );
        } else {
          // 如果Future还未完成，则显示一个加载中的旋转动画。
          return Dialog(
            backgroundColor: Colors.black.withOpacity(0.5),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: 90,
                height: 90,
                child: Center(
                  child: CircularProgressIndicator(), // 加载中动画。
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
