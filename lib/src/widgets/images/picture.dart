import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Picture extends StatelessWidget {
  final Widget image;

  const Picture._(this.image);

  factory Picture({
    required dynamic source,
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    bool matchTextDirection = false,
    Widget Function(BuildContext, Widget, int?, bool)? frameBuilder,
    Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    Color? color,
    BlendMode? colorBlendMode,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
    Map<String, String>? headers,
    double scale = 1.0,
  }) {
    bool isSvg(String path) {
      return path.toLowerCase().endsWith('.svg');
    }

    if (source is String) {
      // Check if the source is likely a URL
      if (Uri.tryParse(source)?.hasAbsolutePath ?? false) {
        return Picture._(Image.network(
          source,
          key: key,
          scale: scale,
          frameBuilder: frameBuilder,
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          width: width,
          height: height,
          color: color,
          fit: fit,
          alignment: alignment,
          colorBlendMode: colorBlendMode,
          filterQuality: filterQuality,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          headers: headers,
        ));
      } else if (isSvg(source)) {
        return Picture._(SvgPicture.asset(
          source,
          key: key,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          matchTextDirection: matchTextDirection,
        ));
      } else {
        return Picture._(Image.asset(
          source,
          key: key,
          scale: scale,
          frameBuilder: frameBuilder,
          errorBuilder: errorBuilder,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          width: width,
          height: height,
          color: color,
          fit: fit,
          alignment: alignment,
          colorBlendMode: colorBlendMode,
          filterQuality: filterQuality,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
        ));
      }
    } else if (source is Uint8List) {
      return Picture._(Image.memory(
        source,
        key: key,
        scale: scale,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        width: width,
        height: height,
        color: color,
        fit: fit,
        alignment: alignment,
        colorBlendMode: colorBlendMode,
        filterQuality: filterQuality,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      ));
    } else if (source is Uri) {
      String path = source.toString();
      if (isSvg(path)) {
        return Picture._(SvgPicture.network(
          path,
          key: key,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          matchTextDirection: matchTextDirection,
        ));
      } else {
        return Picture._(Image.network(
          path,
          key: key,
          scale: scale,
          frameBuilder: frameBuilder,
          errorBuilder: errorBuilder,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          width: width,
          height: height,
          color: color,
          fit: fit,
          alignment: alignment,
          colorBlendMode: colorBlendMode,
          filterQuality: filterQuality,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          headers: headers,
        ));
      }
    } else {
      throw ArgumentError('Unsupported image source type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return image;
  }
}
