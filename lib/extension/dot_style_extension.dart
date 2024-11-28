import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_shader_mark_text/widget/banner_leb/dot_style.dart';

extension DotStyleExtension on DotStyle {
  IconData get getDisPlayIcon {
    switch (this) {
      case DotStyle.none:
        return Icons.hide_source;
      case DotStyle.circle:
        return Icons.circle;
      case DotStyle.heart:
        return Icons.favorite;
      case DotStyle.star:
        return Icons.star;
      case DotStyle.diamond:
        return CupertinoIcons.suit_diamond_fill;
      case DotStyle.square:
        return Icons.square;
    }
  }
}
