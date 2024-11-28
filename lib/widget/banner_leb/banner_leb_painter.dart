import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:test_shader_mark_text/widget/banner_leb/dot_style.dart';

class BannerLebPainter extends CustomPainter {
  final double ledSize;
  final double ledSpacing;
  final Color ledColor;
  final double width;
  final double height;
  final DotStyle dotStyle;

  BannerLebPainter({
    required this.ledSize,
    required this.ledSpacing,
    required this.ledColor,
    required this.width,
    required this.height,
    required this.dotStyle,
  });

  void drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final double radius = size / 2;
    final double innerRadius = radius * 0.4;

    for (int i = 0; i < 10; i++) {
      final double angle = -math.pi / 2 + i * math.pi / 5;
      final double r = i.isEven ? radius : innerRadius;
      final double x = center.dx + math.cos(angle) * r;
      final double y = center.dy + math.sin(angle) * r;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();

    // Điều chỉnh kích thước để trái tim vừa với ledSize
    double width = size;
    double height = size;

    // Di chuyển điểm bắt đầu lên trên một chút để cân đối hơn
    path.moveTo(center.dx, center.dy + height * 0.35);

    // Vẽ nửa trái của trái tim
    path.cubicTo(
        center.dx - width * 0.5, // x1
        center.dy, // y1
        center.dx - width * 0.5, // x2
        center.dy - height * 0.3, // y2
        center.dx, // x3
        center.dy - height * 0.3 // y3
        );

    // Vẽ nửa phải của trái tim
    path.cubicTo(
        center.dx + width * 0.5, // x1
        center.dy - height * 0.3, // y1
        center.dx + width * 0.5, // x2
        center.dy, // y2
        center.dx, // x3
        center.dy + height * 0.35 // y3
        );

    canvas.drawPath(path, paint);
  }

  void drawDiamond(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final double halfSize = size / 2;

    path.moveTo(center.dx, center.dy - halfSize); // top
    path.lineTo(center.dx + halfSize, center.dy); // right
    path.lineTo(center.dx, center.dy + halfSize); // bottom
    path.lineTo(center.dx - halfSize, center.dy); // left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ledColor
      ..style = PaintingStyle.fill;

    if (dotStyle == DotStyle.none) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, width, height),
        paint,
      );
      return;
    }

    // Tính toán lại số cột và hàng để tận dụng tối đa không gian
    final unitSize = ledSize + ledSpacing;
    final cols = (width / unitSize).ceil();
    final rows = (height / unitSize).ceil();

    // Tính toán lại khoảng cách giữa các LED để phân bố đều
    final adjustedSpacingX = (width - (cols * ledSize)) / (cols - 1);
    final adjustedSpacingY = (height - (rows * ledSize)) / (rows - 1);

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x = col * (ledSize + adjustedSpacingX);
        final y = row * (ledSize + adjustedSpacingY);
        final center = Offset(x + ledSize / 2, y + ledSize / 2);

        // Kiểm tra xem LED có nằm trong giới hạn của view không
        if (center.dx + ledSize / 2 <= width &&
            center.dy + ledSize / 2 <= height) {
          switch (dotStyle) {
            case DotStyle.star:
              drawStar(canvas, center, ledSize, paint);
              break;
            case DotStyle.heart:
              drawHeart(canvas, center, ledSize, paint);
              break;
            case DotStyle.circle:
              canvas.drawCircle(center, ledSize / 2, paint);
              break;
            case DotStyle.square:
              canvas.drawRect(
                Rect.fromCenter(
                  center: center,
                  width: ledSize,
                  height: ledSize,
                ),
                paint,
              );
              break;
            case DotStyle.diamond:
              drawDiamond(canvas, center, ledSize, paint);
              break;
            case DotStyle.none:
              break;
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
