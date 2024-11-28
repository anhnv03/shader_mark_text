import 'package:flutter/material.dart';
import 'package:test_shader_mark_text/widget/shader_text/shader_text.dart';
import 'package:test_shader_mark_text/widget/shader_text/shader_text_props.dart';
import 'package:test_shader_mark_text/widget/shader_text/text_run_direction.dart';

class AnimatedShaderMarkText extends StatefulWidget {
  final String data;
  final TextProps textProps;
  final BannerLebProps bannerProps;
  final TextAnimationProps animationProps;
  final BlendMode blendMode;

  const AnimatedShaderMarkText({
    super.key,
    required this.data,
    this.textProps = const TextProps(),
    required this.bannerProps,
    this.animationProps = const TextAnimationProps(),
    this.blendMode = BlendMode.srcIn,
  });

  @override
  State<AnimatedShaderMarkText> createState() => _AnimatedShaderMarkTextState();
}

class _AnimatedShaderMarkTextState extends State<AnimatedShaderMarkText>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Size _textSize = Size.zero;
  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTextSize();
    });
  }

  void _updateTextSize() {
    final RenderBox? renderBox =
        _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _textSize = renderBox.size;
      });
    }
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: widget.animationProps.duration,
      vsync: this,
    );

    if (widget.animationProps.repeat) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  Widget _buildAnimatedText() {
    if (widget.animationProps.direction == TextRunDirection.none) {
      return SizedBox(
        width: widget.bannerProps.width,
        height: widget.bannerProps.height,
        child: Center(
          child: ShaderText(
            key: _textKey,
            data: widget.data,
            textProps: widget.textProps,
            bannerProps: widget.bannerProps,
            blendMode: widget.blendMode,
          ),
        ),
      );
    }

    return ClipRect(
      child: Stack(
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double position = _controller.value - index.toDouble();
              if (position < 0) position += 3;

              double dx = 0.0;
              double dy = 0.0;

              switch (widget.animationProps.direction) {
                case TextRunDirection.leftToRight:
                  dx = -1.0 + position;
                  break;
                case TextRunDirection.rightToLeft:
                  dx = 1.0 - position;
                  break;
                case TextRunDirection.topToBottom:
                  dy = -1.0 + position;
                  break;
                case TextRunDirection.bottomToTop:
                  dy = 1.0 - position;
                  break;
                default:
                  break;
              }

              return Transform.translate(
                offset: Offset(dx * _textSize.width, dy * _textSize.height),
                child: child,
              );
            },
            child: SizedBox(
              width: widget.bannerProps.width,
              height: widget.bannerProps.height,
              child: Center(
                child: ShaderText(
                  data: widget.data,
                  textProps: widget.textProps,
                  bannerProps: widget.bannerProps,
                  blendMode: widget.blendMode,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAnimatedText();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedShaderMarkText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animationProps.direction != oldWidget.animationProps.direction ||
        widget.animationProps.duration != oldWidget.animationProps.duration ||
        widget.animationProps.curve != oldWidget.animationProps.curve ||
        widget.data != oldWidget.data) {
      _controller.dispose();
      _setupAnimation();
    }
  }
}
