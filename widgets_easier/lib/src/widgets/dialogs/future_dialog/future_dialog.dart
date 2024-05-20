import 'package:flutter/material.dart';

// 显示验证过程和结果的对话框。
class FutureDialog extends StatefulWidget {
  final Future<Map<String, dynamic>> Function() futureCallback;
  final Widget loadingDialogBody;
  final Widget Function(String) buildSuccessDialog;
  final Widget Function(String) buildFailureDialog;
  const FutureDialog({
    super.key,
    required this.futureCallback,
    required this.loadingDialogBody,
    required this.buildSuccessDialog,
    required this.buildFailureDialog,
  });

  @override
  State<FutureDialog> createState() => _FutureDialogState();
}

class _FutureDialogState extends State<FutureDialog> {
  late Future<Map<String, dynamic>> _futureResult;

  @override
  void initState() {
    super.initState();
    _futureResult = widget.futureCallback();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _futureResult,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // 如果Future已完成，根据结果显示对应的图标和消息。
          // 延迟1秒后关闭弹窗，并返回结果给上一个页面。
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop(snapshot.data);
          });

          bool status = snapshot.data?['status'] ?? false;
          String data = snapshot.data?['data'];
          // 成功弹窗
          if (status) {
            return widget.buildSuccessDialog(data);
          }
          var _ = widget.buildFailureDialog(data);

          // 失败弹窗
          return _;

          // 构建显示结果的对话框
        } else {
          // 如果Future还未完成，则显示一个加载弹窗
          return widget.loadingDialogBody;
        }
      },
    );
  }
}
