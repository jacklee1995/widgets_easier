import 'package:flutter/material.dart';

import '../../core/core.dart';

/// An on/off toggle, after `el-switch`.
///
/// ```dart
/// WeSwitch(value: on, onChanged: (v) => setState(() => on = v))
/// WeSwitch(value: on, onChanged: ..., activeText: 'On', inactiveText: 'Off')
/// WeSwitch(value: on, onChanged: ..., inlinePrompt: true, activeIcon: Icons.check, inactiveIcon: Icons.close)
/// ```
class WeSwitch extends StatefulWidget {
  const WeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.disabled = false,
    this.loading = false,
    this.size = SizeEnum.defaultSize,
    this.activeText,
    this.inactiveText,
    this.activeIcon,
    this.inactiveIcon,
    this.inlinePrompt = false,
    this.activeColor,
    this.inactiveColor,
    this.type = SemanticEnum.primary,
    this.beforeChange,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool disabled;

  /// Shows a spinner in the knob and blocks input.
  final bool loading;
  final SizeEnum size;

  /// Labels beside the track (or inside it with [inlinePrompt]).
  final String? activeText;
  final String? inactiveText;

  /// Icons inside the track, shown with [inlinePrompt].
  final IconData? activeIcon;
  final IconData? inactiveIcon;

  /// Put the text / icon inside the track instead of beside it.
  final bool inlinePrompt;
  final Color? activeColor;
  final Color? inactiveColor;
  final SemanticEnum type;

  /// Asked before toggling; return `false` to veto. Handy for confirmations.
  final Future<bool> Function()? beforeChange;

  @override
  State<WeSwitch> createState() => _WeSwitchState();
}

class _WeSwitchState extends State<WeSwitch> {
  bool _busy = false;

  bool get _enabled =>
      !widget.disabled && !widget.loading && !_busy && widget.onChanged != null;

  Future<void> _toggle() async {
    if (!_enabled) return;
    if (widget.beforeChange != null) {
      setState(() => _busy = true);
      final ok = await widget.beforeChange!();
      if (!mounted) return;
      setState(() => _busy = false);
      if (!ok) return;
    }
    widget.onChanged!(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final double h = switch (widget.size) {
      SizeEnum.large => 24,
      SizeEnum.defaultSize => 20,
      SizeEnum.small => 16,
    };
    final bool inline = widget.inlinePrompt;
    final double w = inline ? h * 2.6 : h * 2;
    final double knob = h - 4;
    final Color on = widget.activeColor ?? colors.semantic(widget.type);
    final Color off = widget.inactiveColor ?? colors.darkBorder;
    final bool v = widget.value;
    final bool spinning = widget.loading || _busy;

    final Widget track = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: (v ? on : off).withValues(alpha: _enabled ? 1 : 0.5),
        borderRadius: BorderRadius.circular(h / 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (inline)
            Positioned(
              left: v ? 6 : null,
              right: v ? null : 6,
              child: _prompt(v, colors, h),
            ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: v ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: knob,
              height: knob,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: colors.onSemantic,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: spinning
                  ? Padding(
                      padding: EdgeInsets.all(knob * 0.22),
                      child: CircularProgressIndicator(
                        strokeWidth: 1.6,
                        color: v ? on : off,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );

    Widget body = track;
    if (!inline && (widget.activeText != null || widget.inactiveText != null)) {
      TextStyle style(bool active) => TextStyle(
        fontSize: 13,
        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
        color: active ? on : colors.regularText,
      );
      body = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.inactiveText != null) ...[
            Text(widget.inactiveText!, style: style(!v)),
            const SizedBox(width: 8),
          ],
          track,
          if (widget.activeText != null) ...[
            const SizedBox(width: 8),
            Text(widget.activeText!, style: style(v)),
          ],
        ],
      );
    }

    return Semantics(
      toggled: v,
      enabled: _enabled,
      child: FocusableActionDetector(
        enabled: _enabled,
        mouseCursor: _enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _toggle();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggle,
          child: body,
        ),
      ),
    );
  }

  Widget _prompt(bool v, WeColorScheme colors, double h) {
    final IconData? icon = v ? widget.activeIcon : widget.inactiveIcon;
    final String? text = v ? widget.activeText : widget.inactiveText;
    if (icon != null) {
      return Icon(icon, size: h * 0.6, color: colors.onSemantic);
    }
    if (text != null) {
      return Text(
        text,
        style: TextStyle(
          fontSize: h * 0.52,
          fontWeight: FontWeight.w600,
          color: colors.onSemantic,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
