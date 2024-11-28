import 'package:flutter/material.dart';
import 'package:test_shader_mark_text/widget/banner_leb/banner_leb_painter.dart';
import 'package:test_shader_mark_text/widget/banner_leb/dot_style.dart';

class AnimatedBannerLebWidget extends StatefulWidget {
  final double ledSize;
  final double ledSpacing;
  final Color ledColor;
  final Color backgroundColor;
  final double width;
  final double height;
  final DotStyle dotStyle;
  final Duration blinkDuration;
  final bool isBlinking;
  final double minOpacity;
  final Curve blinkCurve;

  const AnimatedBannerLebWidget({
    super.key,
    this.ledSize = 4,
    this.ledSpacing = 1,
    required this.ledColor,
    this.backgroundColor = Colors.black,
    required this.width,
    required this.height,
    this.dotStyle = DotStyle.circle,
    this.blinkDuration = const Duration(milliseconds: 1000),
    this.isBlinking = true,
    this.minOpacity = 0.3,
    this.blinkCurve = Curves.easeInOut,
  });

  @override
  State<AnimatedBannerLebWidget> createState() =>
      _AnimatedBannerLebWidgetState();
}

class _AnimatedBannerLebWidgetState extends State<AnimatedBannerLebWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.blinkDuration,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: widget.minOpacity)
            .chain(CurveTween(curve: widget.blinkCurve)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.minOpacity, end: 1.0)
            .chain(CurveTween(curve: widget.blinkCurve)),
        weight: 50,
      ),
    ]).animate(_controller);

    if (widget.isBlinking) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedBannerLebWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isBlinking != oldWidget.isBlinking) {
      if (widget.isBlinking) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.value = 1.0;
      }
    }
    if (widget.blinkDuration != oldWidget.blinkDuration) {
      _controller.duration = widget.blinkDuration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          color: widget.backgroundColor,
          child: CustomPaint(
            painter: BannerLebPainter(
              ledSize: widget.ledSize,
              ledSpacing: widget.ledSpacing,
              ledColor: widget.ledColor.withOpacity(_animation.value),
              width: widget.width,
              height: widget.height,
              dotStyle: widget.dotStyle,
            ),
            size: Size(widget.width, widget.height),
          ),
        );
      },
    );
  }
}
