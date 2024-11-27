import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:test_shader_mark_text/widget/banner_leb/banner_leb_render.dart';
import 'package:test_shader_mark_text/widget/shader_text/shader_text_props.dart';
import 'package:test_shader_mark_text/widget/shader_text/text_run_direction.dart';

class ShaderText extends StatefulWidget {
  final String data;
  final TextProps textProps;
  final BannerLebProps bannerProps;
  final TextAnimationProps animationProps;
  final BlendMode blendMode;

  const ShaderText({
    super.key,
    required this.data,
    this.textProps = const TextProps(),
    this.bannerProps = const BannerLebProps(),
    this.animationProps = const TextAnimationProps(),
    this.blendMode = BlendMode.srcIn,
  });

  @override
  State<ShaderText> createState() => _ShaderTextState();
}

class _ShaderTextState extends State<ShaderText>
    with SingleTickerProviderStateMixin {
  ui.Image? bannerImage;
  bool isLoading = true;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _renderBannerImage();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationProps.duration,
    );

    _updateAnimation();

    if (widget.animationProps.direction != TextRunDirection.none) {
      if (widget.animationProps.repeat) {
        _controller.repeat();
      } else {
        _controller.forward();
      }
    }
  }

  void _updateAnimation() {
    Offset begin = Offset.zero;
    Offset end = Offset.zero;

    switch (widget.animationProps.direction) {
      case TextRunDirection.leftToRight:
        begin = const Offset(-1.0, 0.0);
        end = const Offset(1.0, 0.0);
        break;
      case TextRunDirection.rightToLeft:
        begin = const Offset(1.0, 0.0);
        end = const Offset(-1.0, 0.0);
        break;
      case TextRunDirection.topToBottom:
        begin = const Offset(0.0, -1.0);
        end = const Offset(0.0, 1.0);
        break;
      case TextRunDirection.bottomToTop:
        begin = const Offset(0.0, 1.0);
        end = const Offset(0.0, -1.0);
        break;
      case TextRunDirection.none:
        begin = end = Offset.zero;
        break;
    }

    _slideAnimation = Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationProps.curve,
    ));
  }

  @override
  void didUpdateWidget(ShaderText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animationProps.direction != widget.animationProps.direction ||
        oldWidget.animationProps.duration != widget.animationProps.duration ||
        oldWidget.animationProps.curve != widget.animationProps.curve) {
      _controller.duration = widget.animationProps.duration;
      _updateAnimation();

      if (widget.animationProps.direction != TextRunDirection.none) {
        if (widget.animationProps.repeat) {
          _controller.repeat();
        } else {
          _controller.forward();
        }
      } else {
        _controller.stop();
      }
    }

    if (_shouldRerenderBanner(oldWidget)) {
      _renderBannerImage();
    }
  }

  bool _shouldRerenderBanner(ShaderText oldWidget) {
    final oldProps = oldWidget.bannerProps;
    final newProps = widget.bannerProps;

    return oldProps.ledSize != newProps.ledSize ||
        oldProps.ledSpacing != newProps.ledSpacing ||
        oldProps.ledColor != newProps.ledColor ||
        oldProps.backgroundColor != newProps.backgroundColor ||
        oldProps.dotStyle != newProps.dotStyle ||
        oldProps.width != newProps.width ||
        oldProps.height != newProps.height;
  }

  Future<void> _renderBannerImage() async {
    setState(() {
      isLoading = true;
    });

    bannerImage?.dispose();

    final image = await BannerLebRenderer.renderToImage(
      ledSize: widget.bannerProps.ledSize,
      ledSpacing: widget.bannerProps.ledSpacing,
      ledColor: widget.bannerProps.ledColor,
      backgroundColor: widget.bannerProps.backgroundColor,
      width: widget.bannerProps.width ?? 400,
      height: widget.bannerProps.height ?? 200,
      dotStyle: widget.bannerProps.dotStyle,
    );

    if (mounted) {
      setState(() {
        bannerImage = image;
        isLoading = false;
      });
    }
  }

  Widget _buildText() {
    Widget text = Text(
      widget.data,
      style: widget.textProps.style?.copyWith(color: Colors.white) ??
          const TextStyle(color: Colors.white),
      strutStyle: widget.textProps.strutStyle,
      textAlign: widget.textProps.textAlign,
      textDirection: widget.textProps.textDirection,
      locale: widget.textProps.locale,
      softWrap: widget.textProps.softWrap,
      overflow: widget.textProps.overflow,
      maxLines: widget.textProps.maxLines,
      semanticsLabel: widget.textProps.semanticsLabel,
      textWidthBasis: widget.textProps.textWidthBasis,
      textHeightBehavior: widget.textProps.textHeightBehavior,
      selectionColor: widget.textProps.selectionColor,
    );

    if (widget.animationProps.direction == TextRunDirection.topToBottom) {
      text = RotatedBox(
        quarterTurns: 1,
        child: text,
      );
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget content = ShaderMask(
      blendMode: widget.blendMode,
      shaderCallback: (bounds) {
        return ImageShader(
          bannerImage!,
          TileMode.clamp,
          TileMode.clamp,
          Matrix4.identity().storage,
        );
      },
      child: _buildText(),
    );

    if (widget.animationProps.direction != TextRunDirection.none) {
      content = SlideTransition(
        position: _slideAnimation,
        child: content,
      );
    }

    return ClipRect(
      child: content,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    bannerImage?.dispose();
    super.dispose();
  }
}
