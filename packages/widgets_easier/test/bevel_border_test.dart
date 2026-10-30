import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';

const Color _light = Color(0xFFE0E0E0);
const Color _dark = Color(0xFF808080);
const Color _backdrop = Color(0xFFFF00FF);

/// Rasterises [shape] over a magenta backdrop on a [size] square.
///
/// Any magenta left inside the frame is a hole the border failed to cover,
/// which is exactly the "cracked" artifact these borders used to have.
Future<ui.Image> _render(ShapeBorder shape, {double size = 40}) {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final rect = Rect.fromLTWH(0, 0, size, size);
  canvas.drawRect(rect, Paint()..color = _backdrop);
  shape.paint(canvas, rect);
  return recorder.endRecording().toImage(size.toInt(), size.toInt());
}

Future<List<Color>> _pixels(ui.Image image) async {
  final data = (await image.toByteData())!;
  return List<Color>.generate(image.width * image.height, (int i) {
    final int o = i * 4;
    return Color.fromARGB(
      data.getUint8(o + 3),
      data.getUint8(o),
      data.getUint8(o + 1),
      data.getUint8(o + 2),
    );
  });
}

/// Colours found in the [width]-thick frame just inside the edges of a
/// [size] square, ignoring the diagonal mitre joins at the four corners.
Future<Set<Color>> _frameColors(
  ShapeBorder shape, {
  required double width,
  double size = 40,
}) async {
  final int n = size.toInt();
  final int w = width.toInt();
  final colors = await _pixels(await _render(shape, size: size));
  final found = <Color>{};
  for (int y = 0; y < n; y++) {
    for (int x = 0; x < n; x++) {
      final bool inFrame = x < w || y < w || x >= n - w || y >= n - w;
      // A mitre runs diagonally through each corner; the pixels it crosses
      // are legitimately blended, so only sample away from the diagonals.
      final bool onMitre = (x - y).abs() <= 1 || (x + y - (n - 1)).abs() <= 1;
      if (inFrame && !onMitre) found.add(colors[y * n + x]);
    }
  }
  return found;
}

void main() {
  group('bevel borders cover their whole frame', () {
    const double width = 8;

    for (final (String name, ShapeBorder shape) in <(String, ShapeBorder)>[
      ('InsetBorder', const InsetBorder(width: width)),
      ('OutsetBorder', const OutsetBorder(width: width)),
      ('GrooveBorder', const GrooveBorder(width: width)),
      ('RidgeBorder', const RidgeBorder(width: width)),
    ]) {
      test('$name leaves no gaps and no stray colours', () async {
        final colors = await _frameColors(shape, width: width);
        expect(
          colors,
          isNot(contains(_backdrop)),
          reason: '$name left an uncovered hole in its frame',
        );
        expect(
          colors,
          everyElement(anyOf(_light, _dark)),
          reason: '$name painted a colour it was never given',
        );
      });
    }

    test('inset and outset are mirror images of each other', () async {
      final inset = await _pixels(
        await _render(const InsetBorder(width: width)),
      );
      final outset = await _pixels(
        await _render(const OutsetBorder(width: width)),
      );
      // Same geometry, swapped palette: every inset pixel is the outset
      // pixel with light and dark exchanged.
      for (int i = 0; i < inset.length; i++) {
        if (inset[i] == _light) expect(outset[i], _dark);
        if (inset[i] == _dark) expect(outset[i], _light);
      }
    });

    test('groove and ridge use both bevels', () async {
      final colors = await _pixels(
        await _render(const GrooveBorder(width: width)),
      );
      // Top edge: outer half dark (inset), inner half light (outset).
      expect(colors[1 * 40 + 20], _dark);
      expect(colors[6 * 40 + 20], _light);
    });

    test('a frame thicker than the box does not fold through itself', () async {
      final colors = await _frameColors(
        const OutsetBorder(width: 100),
        width: 10,
        size: 20,
      );
      expect(colors, isNot(contains(_backdrop)));
    });
  });

  group('bevel border value semantics', () {
    test('equal borders compare equal, different types do not', () {
      expect(const InsetBorder(width: 4), const InsetBorder(width: 4));
      expect(
        const InsetBorder(width: 4).hashCode,
        const InsetBorder(width: 4).hashCode,
      );
      expect(const InsetBorder(width: 4), isNot(const InsetBorder(width: 5)));
      expect(const InsetBorder(width: 4), isNot(const OutsetBorder(width: 4)));
    });

    test('scale and lerp keep the concrete subtype', () {
      expect(const RidgeBorder(width: 4).scale(2), const RidgeBorder(width: 8));
      expect(
        ShapeBorder.lerp(
          const GrooveBorder(width: 0),
          const GrooveBorder(width: 10),
          0.5,
        ),
        const GrooveBorder(width: 5),
      );
    });

    test('dimensions match the declared width', () {
      expect(const InsetBorder(width: 6).dimensions, const EdgeInsets.all(6));
      expect(
        const InsetBorder(
          width: 6,
        ).getInnerPath(const Rect.fromLTWH(0, 0, 40, 40)).getBounds(),
        const Rect.fromLTWH(6, 6, 28, 28),
      );
    });
  });
}
