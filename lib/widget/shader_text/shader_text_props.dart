import 'package:flutter/material.dart';
import 'package:test_shader_mark_text/widget/banner_leb/dot_style.dart';
import 'package:test_shader_mark_text/widget/shader_text/text_run_direction.dart';

class BannerLebProps {
  final double ledSize;
  final double ledSpacing;
  final Color ledColor;
  final Color backgroundColor;
  final DotStyle dotStyle;
  final double width;
  final double height;

  const BannerLebProps({
    this.ledSize = 4,
    this.ledSpacing = 0,
    this.ledColor = Colors.blue,
    this.backgroundColor = Colors.transparent,
    this.dotStyle = DotStyle.none,
    required this.width,
    required this.height,
  });

  BannerLebProps copyWith({
    double? ledSize,
    double? ledSpacing,
    Color? ledColor,
    Color? backgroundColor,
    DotStyle? dotStyle,
    double? width,
    double? height,
  }) {
    return BannerLebProps(
      ledSize: ledSize ?? this.ledSize,
      ledSpacing: ledSpacing ?? this.ledSpacing,
      ledColor: ledColor ?? this.ledColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      dotStyle: dotStyle ?? this.dotStyle,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}

class TextProps {
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  const TextProps({
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  TextProps copyWith({
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) {
    return TextProps(
      style: style ?? this.style,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      locale: locale ?? this.locale,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
      selectionColor: selectionColor ?? this.selectionColor,
    );
  }
}

class TextAnimationProps {
  final TextRunDirection direction;
  final Duration duration;
  final Curve curve;
  final bool repeat;

  const TextAnimationProps({
    this.direction = TextRunDirection.none,
    this.duration = const Duration(seconds: 5),
    this.curve = Curves.linear,
    this.repeat = true,
  });

  TextAnimationProps copyWith({
    TextRunDirection? direction,
    Duration? duration,
    Curve? curve,
    bool? repeat,
  }) {
    return TextAnimationProps(
      direction: direction ?? this.direction,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      repeat: repeat ?? this.repeat,
    );
  }
}
