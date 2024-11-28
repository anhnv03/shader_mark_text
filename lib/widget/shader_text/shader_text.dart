import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:test_shader_mark_text/widget/banner_leb/banner_leb_render.dart';
import 'package:test_shader_mark_text/widget/shader_text/shader_text_props.dart';

class ShaderText extends StatefulWidget {
  final String data;
  final TextProps textProps;
  final BannerLebProps bannerProps;
  final BlendMode blendMode;

  const ShaderText({
    super.key,
    required this.data,
    this.textProps = const TextProps(),
    required this.bannerProps,
    this.blendMode = BlendMode.srcIn,
  });

  @override
  State<ShaderText> createState() => _ShaderTextState();
}

class _ShaderTextState extends State<ShaderText> {
  ui.Image? bannerImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _renderBannerImage();
  }

  @override
  void didUpdateWidget(ShaderText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldRerender(oldWidget)) {
      _renderBannerImage();
    }
  }

  bool _shouldRerender(ShaderText oldWidget) {
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
      width: widget.bannerProps.width,
      height: widget.bannerProps.height,
      dotStyle: widget.bannerProps.dotStyle,
    );

    if (mounted) {
      setState(() {
        bannerImage = image;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ShaderMask(
      blendMode: widget.blendMode,
      shaderCallback: (bounds) {
        return ImageShader(
          bannerImage!,
          TileMode.clamp,
          TileMode.clamp,
          Matrix4.identity().storage,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    bannerImage?.dispose();
    super.dispose();
  }
}
