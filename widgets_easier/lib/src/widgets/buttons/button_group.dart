import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../enums/semantic_enum.dart';
import '../../enums/size_enum.dart';
import 'semantic_button.dart';

/// A widget that displays a group of buttons in a row.
///
/// This widget manages the spacing and the border radius of each button
/// in the group to ensure that they appear as a unified component with
/// appropriate styling for the first, last, and middle buttons.
class ButtonGroup extends StatelessWidget {
  /// A list of [SemanticButton] widgets to display in the group.
  final List<SemanticButton> buttons;

  /// The semantic type of the buttons, which determines their styling.
  /// Defaults to [SemanticEnum.primary].
  final SemanticEnum type;

  /// The size of the buttons, which affects their dimensions.
  /// Defaults to [SizeEnum.defaultSize].
  final SizeEnum size;

  /// The fixed height of the buttons, if specified.
  /// If null, the height is determined by the button's content and [size].
  final double? height;

  /// Whether the buttons should shrink to fit their content.
  /// Defaults to true if not specified.
  final bool? shrink;

  /// The radius for the corners of the first and last button in the group.
  /// Defaults to 4.0.
  final double radius;

  /// The horizontal gap between adjacent buttons in the group.
  /// Defaults to 1.5.
  final double gap;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  /// Creates a [ButtonGroup].
  ///
  /// Requires a list of [SemanticButton]s to be provided as [buttons].
  const ButtonGroup({
    super.key,
    required this.buttons,
    this.type = SemanticEnum.primary,
    this.size = SizeEnum.defaultSize,
    this.height,
    this.shrink,
    this.radius = 4,
    this.gap = 1.5,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buttons.asMap().entries.map((entry) {
        final int index = entry.key;
        final SemanticButton button = entry.value;

        // Determine the border radius for each button based on its position.
        BorderRadiusGeometry? borderRadius;
        if (index == 0) {
          // Apply rounded corners to the left side of the first button.
          borderRadius = BorderRadius.horizontal(
            left: Radius.circular(radius),
          );
        } else if (index == buttons.length - 1) {
          // Apply rounded corners to the right side of the last button.
          borderRadius = BorderRadius.horizontal(
            right: Radius.circular(radius),
          );
        } else {
          // Middle buttons have no rounded corners.
          borderRadius = BorderRadius.zero;
        }

        return Flexible(
          child: Padding(
            // Apply horizontal spacing between buttons, except before the first one.
            padding: EdgeInsets.only(left: index > 0 ? gap : 0),
            child: SemanticButton(
              text: button.text,
              onTap: button.onTap,
              shrink: shrink ?? true,
              type: type,
              size: size,
              height: height,
              borderRadius: borderRadius,
              radius: 0, // Override individual button radius for uniformity.
              prefixIcon: index == 0 ? prefixIcon : null,
              suffixIcon: index == buttons.length - 1 ? suffixIcon : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // 按钮列表，显示所有按钮的基本信息
    properties.add(IterableProperty<SemanticButton>('buttons', buttons));
    // 按钮的语义类型，默认为主要类型
    properties.add(EnumProperty<SemanticEnum>('type', type,
        defaultValue: SemanticEnum.primary));
    // 按钮的大小，默认为默认大小
    properties.add(EnumProperty<SizeEnum>('size', size,
        defaultValue: SizeEnum.defaultSize));
    // 按钮的固定高度，如果未指定，则根据内容和大小确定
    properties.add(DoubleProperty('height', height));
    // 是否应该缩小按钮以适应其内容，默认为真
    properties.add(FlagProperty('shrink',
        value: shrink, ifTrue: 'true', ifFalse: 'false', defaultValue: true));
    // 第一个和最后一个按钮的圆角半径，默认为4.0
    properties.add(DoubleProperty('radius', radius, defaultValue: 4.0));
    // 相邻按钮之间的水平间隙，默认为1.5
    properties.add(DoubleProperty('gap', gap, defaultValue: 1.5));
    properties.add(DiagnosticsProperty<Widget>('prefixIcon', prefixIcon));
    properties.add(DiagnosticsProperty<Widget>('suffixIcon', suffixIcon));
  }
}
