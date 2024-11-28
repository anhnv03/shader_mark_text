import 'package:flutter/material.dart';
import 'package:test_shader_mark_text/widget/shader_text/shader_text.dart';
import 'package:test_shader_mark_text/widget/shader_text/shader_text_props.dart';
import 'package:test_shader_mark_text/widget/shader_text/text_run_direction.dart';

class AnimatedShaderText extends StatefulWidget {
  final String data;
  final TextProps textProps;
  final BannerLebProps bannerProps;
  final TextAnimationProps animationProps;
  final BlendMode blendMode;

  const AnimatedShaderText({
    super.key,
    required this.data,
    this.textProps = const TextProps(),
    this.bannerProps = const BannerLebProps(),
    this.animationProps = const TextAnimationProps(),
    this.blendMode = BlendMode.srcIn,
  });

  @override
  State<AnimatedShaderText> createState() => _AnimatedShaderTextState();
}

class _AnimatedShaderTextState extends State<AnimatedShaderText>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Size _textSize = Size.zero;
  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _updateTextSize();
    // });
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
    final isVertical =
        widget.animationProps.direction == TextRunDirection.topToBottom ||
            widget.animationProps.direction == TextRunDirection.bottomToTop;

    // Measure visible area and content size
    final textSpan = TextSpan(
      text: widget.data,
      style: widget.textProps.style,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    // Check if content fits container
    final contentSize = isVertical
        ? textPainter.height * widget.data.length
        : textPainter.width;

    final containerSize =
        isVertical ? widget.bannerProps.height! : widget.bannerProps.width!;

    final shouldAnimate = contentSize <= containerSize;

    return SizedBox(
      width: widget.bannerProps.width,
      height: widget.bannerProps.height,
      child: ClipRect(
        child: Stack(
          children: shouldAnimate
              ? _buildDuplicatedContent()
              : [_buildSingleContent()],
        ),
      ),
    );
  }

  List<Widget> _buildDuplicatedContent() {
    return List.generate(3, (index) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double position = _controller.value - index.toDouble();
          if (position < 0) position += 3;

          final offset = _calculateOffset(position);
          return Transform.translate(offset: offset, child: child);
        },
        child: _buildTextContent(),
      );
    });
  }

  Widget _buildSingleContent() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = _calculateOffset(_controller.value);
        return Transform.translate(offset: offset, child: child);
      },
      child: _buildTextContent(),
    );
  }

  Offset _calculateOffset(double position) {
    switch (widget.animationProps.direction) {
      case TextRunDirection.leftToRight:
        return Offset(
            -widget.bannerProps.width! + position * widget.bannerProps.width!,
            0);
      case TextRunDirection.rightToLeft:
        return Offset(
            widget.bannerProps.width! - position * widget.bannerProps.width!,
            0);
      case TextRunDirection.topToBottom:
        return Offset(
            0,
            -widget.bannerProps.height! +
                position * widget.bannerProps.height!);
      case TextRunDirection.bottomToTop:
        return Offset(0,
            widget.bannerProps.height! - position * widget.bannerProps.height!);
      default:
        return Offset.zero;
    }
  }

  Widget _buildTextContent() {
    final isVertical =
        widget.animationProps.direction == TextRunDirection.topToBottom ||
            widget.animationProps.direction == TextRunDirection.bottomToTop;

    if (!isVertical) {
      return Center(
          child: ShaderText(
        data: widget.data,
        textProps: widget.textProps,
        bannerProps: widget.bannerProps,
        blendMode: widget.blendMode,
      ));
    }

    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        final fontSize = widget.textProps.style?.fontSize ?? 14.0;
        final lineHeight = fontSize * 1.2; // Add some line spacing
        final maxChars = (constraints.maxHeight / lineHeight).floor();
        final chars = widget.data.split('');
        final spacing = lineHeight * 0.5; // Space between repeating text

        final shouldAnimate =
            chars.length * lineHeight <= constraints.maxHeight;

        if (shouldAnimate) {
          // Add spacing between repeating sequences
          chars.add(' '); // Add space char for gap
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: chars
              .map((char) => SizedBox(
                    height: char == ' ' ? spacing : lineHeight,
                    child: char == ' '
                        ? const SizedBox()
                        : ShaderText(
                            data: char,
                            textProps: widget.textProps,
                            bannerProps: widget.bannerProps,
                            blendMode: widget.blendMode,
                          ),
                  ))
              .toList(),
        );
      }),
    );
  }

  // Widget _buildTextContent() {
  //   final isVertical =
  //       widget.animationProps.direction == TextRunDirection.topToBottom ||
  //           widget.animationProps.direction == TextRunDirection.bottomToTop;
  //
  //   if (!isVertical) {
  //     return Center(
  //       child: ShaderText(
  //         key: _textKey,
  //         data: widget.data,
  //         textProps: widget.textProps,
  //         bannerProps: widget.bannerProps,
  //         blendMode: widget.blendMode,
  //       ),
  //     );
  //   }
  //
  //   return Center(
  //     child: SizedBox(
  //       width: widget.bannerProps.width,
  //       height: widget.bannerProps.height,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: widget.data
  //             .split('')
  //             .map((char) => ShaderText(
  //                   data: char,
  //                   textProps: widget.textProps,
  //                   bannerProps: widget.bannerProps.copyWith(
  //                       height:
  //                           widget.bannerProps.height! / widget.data.length),
  //                   blendMode: widget.blendMode,
  //                 ))
  //             .toList(),
  //       ),
  //     ),
  //   );
  // }

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
  void didUpdateWidget(AnimatedShaderText oldWidget) {
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
