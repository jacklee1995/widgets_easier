import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../buttons/we_button.dart';
import '../../form/we_input.dart';
import 'we_dialog.dart';

/// The three ready-made modals of `ElMessageBox`: alert, confirm and prompt.
///
/// Each one is a [WeDialog], so they are draggable and follow `WeTheme`.
///
/// ```dart
/// if (await WeMessageBox.confirm(context, '删除后不可恢复，继续？')) {
///   await remove();
/// }
/// ```
class WeMessageBox {
  const WeMessageBox._();

  static const double _width = 420;

  /// One button, for telling the user something. Completes with `true` when
  /// the button was pressed, `false` when the dialog was dismissed.
  static Future<bool> alert(
    BuildContext context,
    String message, {
    String? title = '提示',
    String confirmText = '确定',
    SemanticEnum type = SemanticEnum.info,
    IconData? icon,
    Widget? content,
    bool showClose = true,
    bool closeOnClickModal = false,
    double width = _width,
    bool draggable = true,
  }) async {
    final bool? ok = await WeDialog.show<bool>(
      context,
      title: title,
      width: width,
      draggable: draggable,
      showClose: showClose,
      closeOnClickModal: closeOnClickModal,
      builder: (context) =>
          _Body(message: message, type: type, icon: icon, content: content),
      actions: (context) => [
        WeButton(
          text: confirmText,
          type: type == SemanticEnum.info ? SemanticEnum.primary : type,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
    return ok ?? false;
  }

  /// Two buttons. Completes with `true` only when the user confirms.
  static Future<bool> confirm(
    BuildContext context,
    String message, {
    String? title = '提示',
    String confirmText = '确定',
    String cancelText = '取消',
    SemanticEnum type = SemanticEnum.warning,
    IconData? icon,
    Widget? content,
    bool showClose = true,
    bool closeOnClickModal = false,
    double width = _width,
    bool draggable = true,
  }) async {
    final bool? ok = await WeDialog.show<bool>(
      context,
      title: title,
      width: width,
      draggable: draggable,
      showClose: showClose,
      closeOnClickModal: closeOnClickModal,
      builder: (context) =>
          _Body(message: message, type: type, icon: icon, content: content),
      actions: (context) => [
        WeButton(
          text: cancelText,
          variant: WeButtonVariant.plain,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        WeButton(
          text: confirmText,
          type: type == SemanticEnum.info ? SemanticEnum.primary : type,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
    return ok ?? false;
  }

  /// Asks for a line of text. Completes with `null` when cancelled.
  ///
  /// [validator] returns an error message, or `null` when the value is fine;
  /// the confirm button stays disabled until it passes.
  static Future<String?> prompt(
    BuildContext context,
    String message, {
    String? title = '提示',
    String? initialValue,
    String? hint,
    String confirmText = '确定',
    String cancelText = '取消',
    SemanticEnum type = SemanticEnum.info,
    String? Function(String value)? validator,
    bool obscure = false,
    int? maxLength,
    bool showClose = true,
    bool closeOnClickModal = false,
    double width = _width,
    bool draggable = true,
  }) {
    return WeDialog.show<String>(
      context,
      title: title,
      width: width,
      draggable: draggable,
      showClose: showClose,
      closeOnClickModal: closeOnClickModal,
      footer: const SizedBox.shrink(),
      builder: (context) => _Prompt(
        message: message,
        initialValue: initialValue,
        hint: hint,
        confirmText: confirmText,
        cancelText: cancelText,
        type: type,
        validator: validator,
        obscure: obscure,
        maxLength: maxLength,
      ),
    );
  }
}

/// 图标 + 文案，alert / confirm 共用。
class _Body extends StatelessWidget {
  const _Body({
    required this.message,
    required this.type,
    this.icon,
    this.content,
  });

  final String message;
  final SemanticEnum type;
  final IconData? icon;
  final Widget? content;

  static IconData iconFor(SemanticEnum type) => switch (type) {
    SemanticEnum.success => Icons.check_circle_rounded,
    SemanticEnum.warning => Icons.warning_amber_rounded,
    SemanticEnum.danger || SemanticEnum.fatal => Icons.error_rounded,
    _ => Icons.info_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final WeColorScheme colors = context.weColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon ?? iconFor(type), size: 22, color: colors.semantic(type)),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: colors.regularText,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (content != null) ...[const SizedBox(height: 16), content!],
      ],
    );
  }
}

/// prompt 自带页脚，因为确认按钮要跟着校验结果一起启用和禁用。
class _Prompt extends StatefulWidget {
  const _Prompt({
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.type,
    this.initialValue,
    this.hint,
    this.validator,
    this.obscure = false,
    this.maxLength,
  });

  final String message;
  final String confirmText;
  final String cancelText;
  final SemanticEnum type;
  final String? initialValue;
  final String? hint;
  final String? Function(String value)? validator;
  final bool obscure;
  final int? maxLength;

  @override
  State<_Prompt> createState() => _PromptState();
}

class _PromptState extends State<_Prompt> {
  late final TextEditingController _text = TextEditingController(
    text: widget.initialValue,
  );

  String? _error;
  bool _touched = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  bool get _valid => widget.validator?.call(_text.text) == null;

  void _submit() {
    final String? error = widget.validator?.call(_text.text);
    if (error != null) {
      setState(() {
        _touched = true;
        _error = error;
      });
      return;
    }
    Navigator.of(context).pop(_text.text);
  }

  @override
  Widget build(BuildContext context) {
    final WeColorScheme colors = context.weColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.message,
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: colors.regularText,
          ),
        ),
        const SizedBox(height: 14),
        WeInput(
          controller: _text,
          hint: widget.hint,
          autofocus: true,
          obscure: widget.obscure,
          maxLength: widget.maxLength,
          status: _touched && _error != null ? SemanticEnum.danger : null,
          onChanged: (v) => setState(() {
            _error = widget.validator?.call(v);
          }),
          onSubmitted: (_) => _submit(),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.topLeft,
          child: _touched && _error != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _error!,
                    style: TextStyle(fontSize: 12, color: colors.danger),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WeButton(
              text: widget.cancelText,
              variant: WeButtonVariant.plain,
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 10),
            WeButton(
              text: widget.confirmText,
              type: widget.type == SemanticEnum.info
                  ? SemanticEnum.primary
                  : widget.type,
              onPressed: _valid ? _submit : null,
            ),
          ],
        ),
      ],
    );
  }
}
