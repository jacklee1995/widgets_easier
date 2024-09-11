// Copyright 2024 JackLee. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This code is based on the Flutter framework.
// Flutter is licensed under the BSD-style license:
// https://github.com/flutter/flutter/blob/master/LICENSE

import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double _kDegToRad = math.pi / 180;

class SolidStarBorder extends StarBorder {
  const SolidStarBorder({
    super.side,
    super.points = 5,
    super.innerRadiusRatio = 0.4,
    super.pointRounding = 0,
    super.valleyRounding = 0,
    super.rotation = 0,
    super.squash = 0,
    this.borderWidth = 1.0,
    this.borderColor = Colors.black,
    this.borderGradient,
  });

  final double borderWidth;
  final Color borderColor;
  final Gradient? borderGradient;

  @override
  SolidStarBorder copyWith({
    BorderSide? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
    double? borderWidth,
    Color? borderColor,
    Gradient? borderGradient,
  }) {
    return SolidStarBorder(
      side: side ?? this.side,
      points: points ?? this.points,
      rotation: rotation ?? this.rotation,
      innerRadiusRatio: innerRadiusRatio ?? this.innerRadiusRatio,
      pointRounding: pointRounding ?? this.pointRounding,
      valleyRounding: valleyRounding ?? this.valleyRounding,
      squash: squash ?? this.squash,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      borderGradient: borderGradient ?? this.borderGradient,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Rect adjustedRect = rect.deflate(borderWidth / 2);
    final Path path = _StarGenerator(
      points: points,
      rotation: rotation * _kDegToRad,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      valleyRounding: valleyRounding,
      squash: squash,
    ).generate(adjustedRect);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor;

    if (borderGradient != null) {
      paint.shader = borderGradient!.createShader(rect);
    }

    canvas.drawPath(path, paint);
  }
}

class _PointInfo {
  _PointInfo({
    required this.valley,
    required this.point,
    required this.valleyArc1,
    required this.pointArc1,
    required this.valleyArc2,
    required this.pointArc2,
  });

  Offset valley;
  Offset point;
  Offset valleyArc1;
  Offset pointArc1;
  Offset pointArc2;
  Offset valleyArc2;
}

class _StarGenerator {
  const _StarGenerator({
    required this.points,
    required this.innerRadiusRatio,
    required this.pointRounding,
    required this.valleyRounding,
    required this.rotation,
    required this.squash,
  })  : assert(points > 1),
        assert(innerRadiusRatio <= 1),
        assert(innerRadiusRatio >= 0),
        assert(squash >= 0),
        assert(squash <= 1),
        assert(pointRounding >= 0),
        assert(pointRounding <= 1),
        assert(valleyRounding >= 0),
        assert(valleyRounding <= 1),
        assert(pointRounding + valleyRounding <= 1);

  final double points;
  final double innerRadiusRatio;
  final double pointRounding;
  final double valleyRounding;
  final double rotation;
  final double squash;

  Path generate(Rect rect) {
    final double radius = rect.shortestSide / 2;
    final Offset center = rect.center;

    // The minimum allowed inner radius ratio. Numerical instabilities occur near
    // zero, so we just don't allow values in that range.
    const double minInnerRadiusRatio = .002;

    // Map the innerRadiusRatio so that we don't get values close to zero, since
    // things get a little squirrelly there because the path thinks that the
    // length of the conicTo is small enough that it can render it as a straight
    // line, even though it will be scaled up later. This maps the range from
    // [0, 1] to [minInnerRadiusRatio, 1].
    final double mappedInnerRadiusRatio =
        (innerRadiusRatio * (1.0 - minInnerRadiusRatio)) + minInnerRadiusRatio;

    // First, generate the "points" of the star.
    final List<_PointInfo> points = <_PointInfo>[];
    final double maxDiameter = 2.0 *
        _generatePoints(
          pointList: points,
          center: center,
          radius: radius,
          innerRadius: radius * mappedInnerRadiusRatio,
        );

    // Calculate the endpoints of each of the arcs, then draw the arcs.
    final Path path = Path();
    _drawPoints(path, points);

    Offset scale = Offset(rect.width / maxDiameter, rect.height / maxDiameter);
    if (rect.shortestSide == rect.width) {
      scale = Offset(scale.dx, squash * scale.dy + (1 - squash) * scale.dx);
    } else {
      scale = Offset(squash * scale.dx + (1 - squash) * scale.dy, scale.dy);
    }
    // Scale the border so that it matches the size of the widget rectangle, so
    // that "rotation" of the shape doesn't affect how much of the rectangle it
    // covers.
    final Matrix4 squashMatrix =
        Matrix4.translationValues(rect.center.dx, rect.center.dy, 0);
    squashMatrix.multiply(Matrix4.diagonal3Values(scale.dx, scale.dy, 1));
    squashMatrix.multiply(Matrix4.rotationZ(rotation));
    squashMatrix.multiply(
        Matrix4.translationValues(-rect.center.dx, -rect.center.dy, 0));
    return path.transform(squashMatrix.storage);
  }

  double _generatePoints({
    required List<_PointInfo> pointList,
    required Offset center,
    required double radius,
    required double innerRadius,
  }) {
    final double step = math.pi / points;
    // Start initial rotation one step before zero.
    double angle = -math.pi / 2 - step;
    Offset valley = Offset(
      center.dx + math.cos(angle) * innerRadius,
      center.dy + math.sin(angle) * innerRadius,
    );

    // In order to do overall scale properly, calculate the actual radius at the
    // point, taking into account the rounding of the points and the weight of
    // the corner point. This effectively is evaluating the rational quadratic
    // bezier at the midpoint of the curve.
    Offset getCurveMidpoint(
        Offset a, Offset b, Offset c, Offset a1, Offset c1) {
      final double angle = _getAngle(a, b, c);
      final double w = _getWeight(angle) / 2;
      return (a1 / 4 + b * w + c1 / 4) / (0.5 + w);
    }

    double addPoint(
      double pointAngle,
      double pointStep,
      double pointRadius,
      double pointInnerRadius,
    ) {
      pointAngle += pointStep;
      final Offset point = Offset(
        center.dx + math.cos(pointAngle) * pointRadius,
        center.dy + math.sin(pointAngle) * pointRadius,
      );
      pointAngle += pointStep;
      final Offset nextValley = Offset(
        center.dx + math.cos(pointAngle) * pointInnerRadius,
        center.dy + math.sin(pointAngle) * pointInnerRadius,
      );
      final Offset valleyArc1 = valley + (point - valley) * valleyRounding;
      final Offset pointArc1 = point + (valley - point) * pointRounding;
      final Offset pointArc2 = point + (nextValley - point) * pointRounding;
      final Offset valleyArc2 =
          nextValley + (point - nextValley) * valleyRounding;

      pointList.add(_PointInfo(
        valley: valley,
        point: point,
        valleyArc1: valleyArc1,
        pointArc1: pointArc1,
        pointArc2: pointArc2,
        valleyArc2: valleyArc2,
      ));
      valley = nextValley;
      return pointAngle;
    }

    final double remainder = points - points.truncateToDouble();
    final bool hasIntegerSides = remainder < 1e-6;
    final double wholeSides = points - (hasIntegerSides ? 0 : 1);
    for (int i = 0; i < wholeSides; i += 1) {
      angle = addPoint(angle, step, radius, innerRadius);
    }

    double valleyRadius = 0;
    double pointRadius = 0;
    final _PointInfo thisPoint = pointList[0];
    final _PointInfo nextPoint = pointList[1];

    final Offset pointMidpoint = getCurveMidpoint(
        thisPoint.valley,
        thisPoint.point,
        nextPoint.valley,
        thisPoint.pointArc1,
        thisPoint.pointArc2);
    final Offset valleyMidpoint = getCurveMidpoint(
        thisPoint.point,
        nextPoint.valley,
        nextPoint.point,
        thisPoint.valleyArc2,
        nextPoint.valleyArc1);
    valleyRadius = (valleyMidpoint - center).distance;
    pointRadius = (pointMidpoint - center).distance;

    // Add the final point to close the shape if there are fractional sides to
    // account for.
    if (!hasIntegerSides) {
      final double effectiveInnerRadius = math.max(valleyRadius, innerRadius);
      final double endingRadius =
          effectiveInnerRadius + remainder * (radius - effectiveInnerRadius);
      addPoint(angle, step * remainder, endingRadius, innerRadius);
    }

    // The rounding added to the valley radius can sometimes push it outside of
    // the rounding of the point, since the rounding amount can be different
    // between the points and the valleys, so we have to evaluate both the
    // valley and the point radii, and pick the largest. Also, since this value
    // is used later to determine the scale, we need to keep it finite and
    // non-zero.
    return clampDouble(math.max(valleyRadius, pointRadius), double.minPositive,
        double.maxFinite);
  }

  void _drawPoints(Path path, List<_PointInfo> points) {
    final Offset startingPoint = points.first.pointArc1;
    path.moveTo(startingPoint.dx, startingPoint.dy);
    final double pointAngle =
        _getAngle(points[0].valley, points[0].point, points[1].valley);
    final double pointWeight = _getWeight(pointAngle);
    final double valleyAngle =
        _getAngle(points[1].point, points[1].valley, points[0].point);
    final double valleyWeight = _getWeight(valleyAngle);

    for (int i = 0; i < points.length; i += 1) {
      final _PointInfo point = points[i];
      final _PointInfo nextPoint = points[(i + 1) % points.length];
      path.lineTo(point.pointArc1.dx, point.pointArc1.dy);
      if (pointAngle != 180 && pointAngle != 0) {
        path.conicTo(point.point.dx, point.point.dy, point.pointArc2.dx,
            point.pointArc2.dy, pointWeight);
      } else {
        path.lineTo(point.pointArc2.dx, point.pointArc2.dy);
      }
      path.lineTo(point.valleyArc2.dx, point.valleyArc2.dy);
      if (valleyAngle != 180 && valleyAngle != 0) {
        path.conicTo(nextPoint.valley.dx, nextPoint.valley.dy,
            nextPoint.valleyArc1.dx, nextPoint.valleyArc1.dy, valleyWeight);
      } else {
        path.lineTo(nextPoint.valleyArc1.dx, nextPoint.valleyArc1.dy);
      }
    }
    path.close();
  }

  double _getWeight(double angle) {
    return math.cos((angle / 2) % (math.pi / 2));
  }

  // Returns the included angle between points ABC in radians.
  double _getAngle(Offset a, Offset b, Offset c) {
    if (a == c || b == c || b == a) {
      return 0;
    }
    final Offset u = a - b;
    final Offset v = c - b;
    final double dot = u.dx * v.dx + u.dy * v.dy;
    final double m1 = b.dx == a.dx ? double.infinity : -u.dy / -u.dx;
    final double m2 = b.dx == c.dx ? double.infinity : -v.dy / -v.dx;
    double angle = math.atan2(m1 - m2, 1 + m1 * m2).abs();
    if (dot < 0) {
      angle += math.pi;
    }
    return angle;
  }
}
