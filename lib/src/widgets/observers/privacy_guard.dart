import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// PrivacyGuard 组件，用于在应用进入后台时保护隐私
class PrivacyGuard extends StatefulWidget {
  /// 被保护的子组件
  final Widget child;

  /// 模糊半径
  final double blurRadius;

  /// 模糊颜色
  final Color blurColor;

  /// 进入隐私模式时的回调
  final VoidCallback? onEnterPrivacyMode;

  /// 退出隐私模式时的回调
  final VoidCallback? onExitPrivacyMode;

  /// 截屏时的回调
  final VoidCallback? onScreenshot;

  /// 录音尝试时的回调
  final VoidCallback? onRecordingAttempt;

  /// 是否禁止截屏
  final bool preventScreenshot;

  /// 是否禁止录音
  final bool preventRecording;

  const PrivacyGuard({
    super.key,
    required this.child,
    this.blurRadius = 10.0,
    this.blurColor = const Color.fromARGB(136, 225, 225, 225),
    this.onEnterPrivacyMode,
    this.onExitPrivacyMode,
    this.onScreenshot,
    this.onRecordingAttempt,
    this.preventScreenshot = false,
    this.preventRecording = false,
  });

  @override
  State<PrivacyGuard> createState() => _PrivacyGuardState();
}

class _PrivacyGuardState extends State<PrivacyGuard>
    with WidgetsBindingObserver {
  bool _isInPrivacyMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setPreventScreenshot(widget.preventScreenshot);
    _setPreventRecording(widget.preventRecording);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      setState(() {
        _isInPrivacyMode = true;
      });
      widget.onEnterPrivacyMode?.call();
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        _isInPrivacyMode = false;
      });
      widget.onExitPrivacyMode?.call();
    }
  }

  /// 设置是否禁止截屏
  void _setPreventScreenshot(bool prevent) {
    if (prevent) {
      SystemChannels.platform
          .invokeMethod('SystemChrome.setPreventScreenshot', true);
      SystemChannels.platform.setMethodCallHandler((call) async {
        if (call.method == 'SystemChrome.screenshotAttempt') {
          widget.onScreenshot?.call();
        }
      });
    } else {
      SystemChannels.platform
          .invokeMethod('SystemChrome.setPreventScreenshot', false);
    }
  }

  /// 设置是否禁止录音
  void _setPreventRecording(bool prevent) {
    if (prevent) {
      SystemChannels.platform
          .invokeMethod('SystemChrome.setPreventRecording', true);
      SystemChannels.platform.setMethodCallHandler((call) async {
        if (call.method == 'SystemChrome.recordingAttempt') {
          widget.onRecordingAttempt?.call();
        }
      });
    } else {
      SystemChannels.platform
          .invokeMethod('SystemChrome.setPreventRecording', false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isInPrivacyMode)
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: widget.blurRadius, sigmaY: widget.blurRadius),
            child: Container(
              color: widget.blurColor,
            ),
          ),
      ],
    );
  }
}
