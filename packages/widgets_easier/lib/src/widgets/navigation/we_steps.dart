import 'package:flutter/material.dart';

import '../../core/core.dart';

/// The state of one step in [WeSteps].
enum WeStepStatus { wait, process, finish, error, success }

/// One step of a [WeSteps].
class WeStep {
  const WeStep({required this.title, this.description, this.icon, this.status});

  final String title;
  final String? description;

  /// Replaces the numbered circle with a bare icon.
  final IconData? icon;

  /// Overrides the status that [WeSteps.active] would give this step.
  final WeStepStatus? status;
}

/// A progress indicator for a multi-step flow, after `el-steps`.
///
/// Steps before [active] take [finishStatus], the step at [active] takes
/// [processStatus] and the rest wait. A [WeStep.status] overrides that, e.g.
/// to mark a failed step as [WeStepStatus.error].
///
/// ```dart
/// WeSteps(
///   active: 1,
///   steps: const [
///     WeStep(title: 'Paid'),
///     WeStep(title: 'Shipped', description: 'SF Express'),
///     WeStep(title: 'Delivered'),
///   ],
/// )
/// ```
class WeSteps extends StatelessWidget {
  const WeSteps({
    super.key,
    required this.steps,
    this.active = 0,
    this.direction = Axis.horizontal,
    this.finishStatus = WeStepStatus.finish,
    this.processStatus = WeStepStatus.process,
    this.alignCenter = false,
    this.simple = false,
    this.space,
    this.onTap,
  });

  final List<WeStep> steps;

  /// Index of the current step. `steps.length` marks every step finished.
  final int active;
  final Axis direction;
  final WeStepStatus finishStatus;
  final WeStepStatus processStatus;

  /// Centres each title under its icon (horizontal only).
  final bool alignCenter;

  /// A compact single row of titles separated by chevrons.
  final bool simple;

  /// Fixed width (horizontal) or height (vertical) of each step. `null`
  /// shares the space evenly.
  final double? space;

  /// Makes steps clickable, e.g. to jump back in a wizard.
  final ValueChanged<int>? onTap;

  WeStepStatus statusOf(int i) =>
      steps[i].status ??
      (i < active
          ? finishStatus
          : i == active
          ? processStatus
          : WeStepStatus.wait);

  @override
  Widget build(BuildContext context) {
    if (simple) return _buildSimple(context);
    return direction == Axis.horizontal
        ? _buildHorizontal(context)
        : _buildVertical(context);
  }

  Widget _tappable(int i, Widget child) {
    if (onTap == null) return child;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap!(i),
        child: child,
      ),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    final colors = context.weColors;
    final children = <Widget>[];
    for (int i = 0; i < steps.length; i++) {
      final status = statusOf(i);
      final last = i == steps.length - 1;
      final line = _Line(color: _lineColor(colors, status));
      final Widget head = alignCenter
          ? Row(
              children: [
                Expanded(
                  child: i == 0
                      ? const SizedBox()
                      : _Line(color: _lineColor(colors, statusOf(i - 1))),
                ),
                _Head(index: i, step: steps[i], status: status),
                Expanded(child: last ? const SizedBox() : line),
              ],
            )
          : Row(
              children: [
                _Head(index: i, step: steps[i], status: status),
                if (!last) Expanded(child: line),
              ],
            );
      final Widget step = _tappable(
        i,
        Column(
          crossAxisAlignment: alignCenter
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            head,
            Padding(
              padding: EdgeInsets.only(
                right: alignCenter || last ? 0 : 16,
                left: alignCenter ? 8 : 0,
                top: 8,
              ),
              child: _Texts(
                step: steps[i],
                status: status,
                align: alignCenter ? TextAlign.center : TextAlign.start,
              ),
            ),
          ],
        ),
      );
      if (space != null) {
        children.add(SizedBox(width: space, child: step));
      } else if (last && !alignCenter) {
        children.add(Flexible(child: step));
      } else {
        children.add(Expanded(child: step));
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildVertical(BuildContext context) {
    final colors = context.weColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < steps.length; i++)
          _tappable(
            i,
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: i == steps.length - 1 ? 0 : space ?? 72,
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        _Head(index: i, step: steps[i], status: statusOf(i)),
                        if (i < steps.length - 1)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: _Line(
                                color: _lineColor(colors, statusOf(i)),
                                vertical: true,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 2,
                          bottom: i == steps.length - 1 ? 0 : 16,
                        ),
                        child: _Texts(step: steps[i], status: statusOf(i)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSimple(BuildContext context) {
    final colors = context.weColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.lightFill,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            Expanded(
              child: _tappable(
                i,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Head(
                      index: i,
                      step: steps[i],
                      status: statusOf(i),
                      diameter: 18,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        steps[i].title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _titleStyle(colors, statusOf(i)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (i < steps.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: colors.placeholderText,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

Color _statusColor(WeColorScheme c, WeStepStatus s) => switch (s) {
  WeStepStatus.wait => c.placeholderText,
  WeStepStatus.process => c.primaryText,
  WeStepStatus.finish => c.primary,
  WeStepStatus.error => c.danger,
  WeStepStatus.success => c.success,
};

Color _lineColor(WeColorScheme c, WeStepStatus s) => switch (s) {
  WeStepStatus.finish || WeStepStatus.success => _statusColor(c, s),
  _ => c.lightBorder,
};

TextStyle _titleStyle(WeColorScheme c, WeStepStatus s) => TextStyle(
  fontSize: 14,
  height: 1.4,
  fontWeight: s == WeStepStatus.process ? FontWeight.w600 : FontWeight.w500,
  color: _statusColor(c, s),
);

class _Line extends StatelessWidget {
  const _Line({required this.color, this.vertical = false});

  final Color color;
  final bool vertical;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: vertical ? 2 : null,
      height: vertical ? null : 2,
      margin: vertical ? null : const EdgeInsets.symmetric(horizontal: 8),
      color: color,
    ),
  );
}

class _Head extends StatelessWidget {
  const _Head({
    required this.index,
    required this.step,
    required this.status,
    this.diameter = 24,
  });

  final int index;
  final WeStep step;
  final WeStepStatus status;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final color = _statusColor(colors, status);
    if (step.icon != null) {
      return SizedBox(
        width: diameter,
        height: diameter,
        child: Icon(step.icon, size: diameter, color: color),
      );
    }
    final IconData? mark = switch (status) {
      WeStepStatus.finish || WeStepStatus.success => Icons.check,
      WeStepStatus.error => Icons.close,
      _ => null,
    };
    return Container(
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.baseBackground,
        border: Border.all(color: color, width: 2),
      ),
      child: mark != null
          ? Icon(mark, size: diameter * 0.6, color: color)
          : Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: diameter * 0.5,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1,
              ),
            ),
    );
  }
}

class _Texts extends StatelessWidget {
  const _Texts({
    required this.step,
    required this.status,
    this.align = TextAlign.start,
  });

  final WeStep step;
  final WeStepStatus status;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    return Column(
      crossAxisAlignment: align == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(step.title, textAlign: align, style: _titleStyle(colors, status)),
        if (step.description != null) ...[
          const SizedBox(height: 4),
          Text(
            step.description!,
            textAlign: align,
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: status == WeStepStatus.wait
                  ? colors.placeholderText
                  : _statusColor(colors, status).withValues(alpha: 0.85),
            ),
          ),
        ],
      ],
    );
  }
}
