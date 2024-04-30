import 'package:flutter/material.dart';

import '../../enums/size_enum.dart';
import '../../enums/semantic_enum.dart';
import '../../enums/effect_enum.dart';
import '../../color/utils.dart';

class Tag extends StatelessWidget {
  final Widget child;

  /// Tag 的类型
  final SemanticEnum type;

  /// 定义一个标签是否可移除
  final bool closable;

  /// 背景色
  final Color? color;

  /// Tag 的尺寸
  final SizeEnum size;

  /// Tag 是否为圆形
  final bool round;

  /// 是否选中
  final bool? checked;

  /// 移除时的回调
  final VoidCallback? onClose;

  /// Tag 的主题
  final EffectEnum effect;

  /// 自定义高度
  final double? height;

  const Tag({
    super.key,
    required this.child,
    this.type = SemanticEnum.primary,
    this.closable = false,
    this.color,
    this.size = SizeEnum.defaultSize,
    this.round = false,
    this.checked,
    this.onClose,
    this.effect = EffectEnum.light,
    this.height,
  });

  /// 根据TagSize枚举值返回相应的字体大小
  double _getFontSize() {
    switch (size) {
      case SizeEnum.large:
        return 18.0;
      case SizeEnum.small:
        return 12.0;
      case SizeEnum.defaultSize:
      default:
        return 14.0;
    }
  }

  /// 计算最终的背景色
  Color _getBackgroundColor(BuildContext context) {
    if (effect == EffectEnum.plain) {
      return Colors.transparent; // plain效果下背景透明
    }
    if (color != null) return color!;
    if (checked != null && checked!) {
      return Colors.grey[300]!;
    }
    return findStatusColor(type).withOpacity(0.1);
  }

  Color _getTextColor(BuildContext context) {
    // 根据effect调整文字颜色
    if (effect == EffectEnum.plain) {
      return findStatusColor(type); // plain效果下使用type对应的颜色
    }
    return findStatusColor(type);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? _getHeightForSize(size),
      padding: EdgeInsets.symmetric(
          horizontal: 10, vertical: size == SizeEnum.small ? 2 : 4),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(round ? 20 : 3),
        border: Border.all(color: findStatusColor(type)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextStyle(
            style: TextStyle(
              fontSize: _getFontSize(),
              color: _getTextColor(context),
            ),
            child: child,
          ),
          if (closable)
            GestureDetector(
              onTap: () {
                if (onClose != null) {
                  onClose!();
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: findStatusColor(type),
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  Icons.close,
                  size: _getFontSize(),
                  color: _getTextColor(context),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _getHeightForSize(SizeEnum size) {
    switch (size) {
      case SizeEnum.small:
        return 20;
      case SizeEnum.large:
        return 40;
      default:
        return 30;
    }
  }
}
