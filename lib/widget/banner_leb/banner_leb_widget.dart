import 'package:flutter/material.dart';
import 'package:test_shader_mark_text/widget/banner_leb/banner_leb_painter.dart';
import 'package:test_shader_mark_text/widget/banner_leb/dot_style.dart';

class BannerLebWidget extends StatelessWidget {
  final double ledSize;
  final double ledSpacing;
  final Color ledColor;
  final Color backgroundColor;
  final double width;
  final double height;
  final DotStyle dotStyle;

  const BannerLebWidget({
    super.key,
    this.ledSize = 4,
    this.ledSpacing = 1,
    required this.ledColor,
    this.backgroundColor = Colors.black,
    required this.width,
    required this.height,
    this.dotStyle = DotStyle.circle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      child: CustomPaint(
        painter: BannerLebPainter(
          ledSize: ledSize,
          ledSpacing: ledSpacing,
          ledColor: ledColor,
          width: width,
          height: height,
          dotStyle: dotStyle,
        ),
        size: Size(width, height),
      ),
    );
  }
}
