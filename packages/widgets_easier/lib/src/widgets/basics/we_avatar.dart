import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Shape of a [WeAvatar].
enum WeAvatarShape { circle, square }

/// A user or entity picture with text and icon fallbacks, after `el-avatar`.
///
/// Give one of [image], [text] or [icon]. Text avatars pick a stable
/// background colour from the text so the same name always looks the same.
///
/// ```dart
/// WeAvatar(text: '张')
/// WeAvatar(image: NetworkImage(url), size: 48)
/// WeAvatar(icon: Icons.storefront, shape: WeAvatarShape.square)
/// ```
class WeAvatar extends StatelessWidget {
  const WeAvatar({
    super.key,
    this.image,
    this.text,
    this.icon,
    this.size = 36,
    this.shape = WeAvatarShape.circle,
    this.color,
    this.foregroundColor,
    this.border = false,
  });

  final ImageProvider? image;
  final String? text;
  final IconData? icon;
  final double size;
  final WeAvatarShape shape;

  /// Background for text and icon avatars. Defaults to a hue picked from
  /// [text], or the theme's fill for icons.
  final Color? color;
  final Color? foregroundColor;

  /// Draw a thin ring in the base background colour so the avatar stands
  /// out against another avatar or a coloured surface.
  final bool border;

  static const List<Color> _palette = [
    Color(0xFF409EFF),
    Color(0xFF67C23A),
    Color(0xFFE6A23C),
    Color(0xFFF56C6C),
    Color(0xFF9B59B6),
    Color(0xFF1ABC9C),
    Color(0xFFE67E22),
    Color(0xFF34495E),
  ];

  @override
  Widget build(BuildContext context) {
    final we = WeTheme.of(context);
    final colors = we.colors;
    final BorderRadius radius = BorderRadius.circular(
      shape == WeAvatarShape.circle ? size / 2 : we.radius.base,
    );

    Color bg;
    Widget child;
    if (image != null) {
      bg = colors.lightFill;
      child = Image(
        image: image!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Icon(
          Icons.person_outline,
          size: size * 0.55,
          color: colors.placeholderText,
        ),
      );
    } else if (text != null && text!.isNotEmpty) {
      final String t = text!.trim();
      bg =
          color ??
          _palette[t.codeUnits.fold(0, (a, b) => a + b) % _palette.length];
      final String shown = t.length > 2 && !t.startsWith('+')
          ? t.substring(0, 1)
          : t;
      child = Text(
        shown,
        style: TextStyle(
          fontSize: size * (shown.length > 1 ? 0.36 : 0.44),
          fontWeight: FontWeight.w600,
          height: 1,
          color: foregroundColor ?? colors.onSemantic,
        ),
      );
    } else {
      bg = color ?? colors.baseFill;
      child = Icon(
        icon ?? Icons.person_outline,
        size: size * 0.56,
        color: foregroundColor ?? colors.secondaryText,
      );
    }

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        border: border
            ? Border.all(color: colors.baseBackground, width: 2)
            : null,
      ),
      child: child,
    );
  }
}

/// A row of overlapping [WeAvatar]s with a `+N` overflow, after
/// `el-avatar` stacks seen in team headers.
class WeAvatarGroup extends StatelessWidget {
  const WeAvatarGroup({
    super.key,
    required this.avatars,
    this.max = 4,
    this.size = 32,
    this.overlap = 10,
  });

  final List<WeAvatar> avatars;
  final int max;
  final double size;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    final colors = context.weColors;
    final shown = avatars.take(max).toList();
    final int rest = avatars.length - shown.length;
    final int count = shown.length + (rest > 0 ? 1 : 0);
    return SizedBox(
      width: size + (count - 1) * (size - overlap),
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < shown.length; i++)
            Positioned(
              left: i * (size - overlap),
              child: WeAvatar(
                image: shown[i].image,
                text: shown[i].text,
                icon: shown[i].icon,
                color: shown[i].color,
                size: size,
                border: true,
              ),
            ),
          if (rest > 0)
            Positioned(
              left: shown.length * (size - overlap),
              child: WeAvatar(
                text: '+$rest',
                color: colors.baseFill,
                foregroundColor: colors.regularText,
                size: size,
                border: true,
              ),
            ),
        ],
      ),
    );
  }
}
