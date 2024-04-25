// import 'package:flutter/material.dart';

// import 'button_size.dart';

// class GeneralButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onTap;
//   final Color backgroundColor;
//   final bool isOutlined;
//   final BorderSide? outlineStyle;
//   final double? height;
//   final double radius;
//   final double fontSize;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final ButtonSize size;

//   const GeneralButton({
//     Key? key,
//     required this.text,
//     this.onTap,
//     this.backgroundColor = Colors.blue,
//     this.isOutlined = false,
//     this.outlineStyle,
//     this.height,
//     this.radius = 10,
//     this.fontSize = 18,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.size = ButtonSize.defaultSize,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double finalHeight = height ?? _getHeightFromSize(size);
//     Color effectiveBackgroundColor =
//         onTap != null ? backgroundColor : Colors.grey;
//     BorderSide effectiveOutlineStyle =
//         outlineStyle ?? BorderSide(color: backgroundColor);

//     return MouseRegion(
//       cursor: onTap != null
//           ? SystemMouseCursors.click
//           : SystemMouseCursors.forbidden,
//       child: Material(
//         color: isOutlined ? Colors.transparent : effectiveBackgroundColor,
//         borderRadius: BorderRadius.circular(radius),
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(radius),
//           child: Container(
//             height: finalHeight,
//             decoration: BoxDecoration(
//               border: isOutlined
//                   ? Border.all(
//                       color: effectiveOutlineStyle.color,
//                       width: effectiveOutlineStyle.width)
//                   : null,
//               borderRadius: BorderRadius.circular(radius),
//               color: Colors.transparent,
//             ),
//             alignment: Alignment.center,
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (prefixIcon != null) ...[
//                   prefixIcon!,
//                   const SizedBox(width: 8),
//                 ],
//                 Text(
//                   text,
//                   textAlign: TextAlign.center,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: fontSize,
//                     fontWeight: FontWeight.w600,
//                     color: isOutlined ? backgroundColor : Colors.white,
//                   ),
//                 ),
//                 if (suffixIcon != null) ...[
//                   const SizedBox(width: 8),
//                   suffixIcon!,
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   double _getHeightFromSize(ButtonSize size) {
//     switch (size) {
//       case ButtonSize.small:
//         return 20;
//       case ButtonSize.large:
//         return 40;
//       default:
//         return 30;
//     }
//   }
// }
