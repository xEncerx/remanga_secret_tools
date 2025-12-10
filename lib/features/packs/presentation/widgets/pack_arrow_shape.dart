import 'package:flutter/material.dart';

/// Arrow-shaped bar with optional gradient and rotation.
class PackArrowShape extends StatelessWidget {
  /// Creates a [PackArrowShape] widget.
  const PackArrowShape({
    super.key,
    this.width = double.infinity,
    this.height = 80,
    this.angle = 0,
    this.gradient,
    this.color,
  });

  /// The width of the arrow shape.
  final double width;

  /// The height of the arrow shape.
  final double height;

  /// The rotation angle of the arrow shape in radians.
  final double angle; // Radians
  /// The gradient to fill the arrow shape.
  final Gradient? gradient;

  /// The color to fill the arrow shape if no gradient is provided.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    final Widget painted = CustomPaint(
      size: Size(width, height),
      painter: _ArrowPainter(
        gradient: gradient,
        color: color ?? primaryColor,
      ),
    );

    if (angle == 0) {
      return painted;
    }

    return Transform.rotate(
      angle: angle,
      child: painted,
    );
  }
}

class _ArrowPainter extends CustomPainter {
  _ArrowPainter({
    required this.gradient,
    required this.color,
  });

  final Gradient? gradient;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleY = size.height / 80;
    final double tailX = size.width;

    canvas.scale(1, scaleY);

    final path = Path()
      ..moveTo(369.0, 0.0)
      ..lineTo(43.4125, 0.0)
      ..cubicTo(39.9298, 0.0, 36.5721, 1.2981, 33.9951, 3.64084)
      ..lineTo(5.39509, 29.6408)
      ..cubicTo(-0.71502, 35.1955, -0.715029, 44.8045, 5.39508, 50.3592)
      ..lineTo(33.9951, 76.3592)
      ..cubicTo(36.5721, 78.7019, 39.9298, 80.0, 43.4125, 80.0)
      ..lineTo(369.0, 80.0)
      ..lineTo(tailX, 80.0)
      ..lineTo(tailX, 0.0)
      ..lineTo(369.0, 0.0)
      ..close();

    final Rect rect = Rect.fromLTWH(0, 0, size.width, 80);

    final Paint paint = Paint()
      ..shader =
          (gradient ??
                  LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.4),
                      color.withValues(alpha: 0.0),
                    ],
                  ))
              .createShader(rect);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) {
    return oldDelegate.gradient != gradient || oldDelegate.color != color;
  }
}
