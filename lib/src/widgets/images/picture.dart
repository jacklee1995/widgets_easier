import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Picture extends StatelessWidget {
  final Widget image;

  const Picture._(this.image);

  factory Picture({
    required String source,
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
    bool cache = false,
    BoxBorder? border,
    BorderRadius? borderRadius,
    ShapeBorderClipper? clipper,
    double opacity = 1.0,
  }) {
    Widget unsupportedImage = Container(
      width: width,
      height: height,
      color: Colors.blueGrey,
      alignment: alignment,
      padding: const EdgeInsets.all(3),
      child: FittedBox(
        fit: fit,
        child: const Center(
          child: Text(
            'Unsupported Image',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
    bool isSvg(String path) {
      return path.toLowerCase().contains('<svg');
    }

    bool isBase64(String str) {
      final base64Regex = RegExp(
          r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$');
      return base64Regex.hasMatch(str);
    }

    bool isUrl(String url) {
      Uri? uri = Uri.tryParse(url);
      return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    }

    try {
      Widget imageWidget;
      if (source.startsWith('asset')) {
        try {
          imageWidget = Image.asset(
            source,
            key: key,
            scale: scale,
            frameBuilder: frameBuilder,
            errorBuilder: (_, __, ___) => unsupportedImage,
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
          );
        } catch (e) {
          try {
            imageWidget = SvgPicture.asset(
              source,
              key: key,
              width: width,
              height: height,
              fit: fit,
              alignment: alignment,
              matchTextDirection: matchTextDirection,
            );
          } catch (e) {
            imageWidget = unsupportedImage;
          }
        }
      } else if (isUrl(source)) {
        if (source.contains('svg')) {
          try {
            imageWidget = SvgPicture.network(
              source,
              key: key,
              width: width,
              height: height,
              fit: fit,
              alignment: alignment,
              matchTextDirection: matchTextDirection,
            );
          } catch (e) {
            imageWidget = unsupportedImage;
          }
        } else {
          imageWidget = Image.network(
            source,
            key: key,
            scale: scale,
            frameBuilder: frameBuilder,
            loadingBuilder: loadingBuilder,
            errorBuilder: (_, __, ___) => unsupportedImage,
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
          );
        }
      } else if (isBase64(source)) {
        final Uint8List bytes = base64.decode(source);
        try {
          imageWidget = Image.memory(
            bytes,
            key: key,
            scale: scale,
            frameBuilder: frameBuilder,
            errorBuilder: (_, __, ___) => unsupportedImage,
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
          );
        } catch (e) {
          try {
            imageWidget = SvgPicture.memory(
              bytes,
              key: key,
              width: width,
              height: height,
              fit: fit,
              alignment: alignment,
              matchTextDirection: matchTextDirection,
            );
          } catch (e) {
            imageWidget = unsupportedImage;
          }
        }
      } else if (isSvg(source)) {
        try {
          imageWidget = SvgPicture.string(
            source,
            key: key,
            width: width,
            height: height,
            fit: fit,
            alignment: alignment,
            matchTextDirection: matchTextDirection,
          );
        } catch (e) {
          imageWidget = unsupportedImage;
        }
      } else {
        imageWidget = unsupportedImage;
      }

      return Picture._(
        SizedBox(
          width: width,
          height: height,
          child: width != null && height != null
              ? Align(
                  alignment: alignment,
                  child: Opacity(
                    opacity: opacity,
                    child: Stack(
                      children: [
                        ClipPath(
                          clipper: clipper,
                          child: Container(
                            child: imageWidget,
                          ),
                        ),
                        if (clipper != null)
                          CustomPaint(
                            painter: _BorderPainter(
                              shape: clipper.shape,
                            ),
                            child: SizedBox(
                              width: width,
                              height: height,
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              : FittedBox(
                  fit: fit,
                  alignment: alignment,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 1,
                      minHeight: 1,
                    ),
                    child: Opacity(
                      opacity: opacity,
                      child: Stack(
                        children: [
                          ClipPath(
                            clipper: clipper,
                            child: Container(
                              child: imageWidget,
                            ),
                          ),
                          if (clipper != null)
                            CustomPaint(
                              painter: _BorderPainter(
                                shape: clipper.shape,
                              ),
                              child: SizedBox(
                                width: width,
                                height: height,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      );
    } catch (e, stackTrace) {
      return Picture._(Builder(
        builder: (BuildContext context) {
          if (errorBuilder != null) {
            return errorBuilder(context, e, stackTrace);
          } else {
            return unsupportedImage;
          }
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return image;
  }
}

class _BorderPainter extends CustomPainter {
  final ShapeBorder shape;

  _BorderPainter({required this.shape});

  @override
  void paint(Canvas canvas, Size size) {
    shape.paint(canvas, Offset.zero & size);
  }

  @override
  bool shouldRepaint(_BorderPainter oldDelegate) {
    return oldDelegate.shape != shape;
  }
}
