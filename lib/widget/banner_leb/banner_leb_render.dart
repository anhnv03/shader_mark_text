import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_shader_mark_text/widget/banner_leb/banner_leb_painter.dart';
import 'package:test_shader_mark_text/widget/banner_leb/dot_style.dart';

class BannerLebRenderer {
  static Future<ui.Image> renderToImage({
    required double ledSize,
    required double ledSpacing,
    required Color ledColor,
    required Color backgroundColor,
    required double width,
    required double height,
    DotStyle dotStyle = DotStyle.circle,
  }) async {
    // Tạo một PictureRecorder để ghi lại các thao tác vẽ
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Vẽ background
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), backgroundPaint);

    // Vẽ LED pattern
    final painter = BannerLebPainter(
      ledSize: ledSize,
      ledSpacing: ledSpacing,
      ledColor: ledColor,
      width: width,
      height: height,
      dotStyle: dotStyle,
    );
    painter.paint(canvas, Size(width, height));

    // Chuyển đổi thành Picture
    final picture = recorder.endRecording();

    // Chuyển đổi Picture thành Image
    final image = await picture.toImage(
      width.toInt(),
      height.toInt(),
    );

    return image;
  }

  // Phương thức helper để chuyển đổi Image thành Uint8List (bytes)
  static Future<Uint8List> imageToBytes(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
