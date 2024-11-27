import 'package:flutter/material.dart';
import 'package:test_shader_mark_text/widget/shader_text/text_run_direction.dart';

extension TextRunDirectionExtension on TextRunDirection {
  IconData get iconDisplay {
    switch (this) {
      case TextRunDirection.leftToRight:
        return Icons.arrow_right;
      case TextRunDirection.rightToLeft:
        return Icons.arrow_left;
      case TextRunDirection.topToBottom:
        return Icons.arrow_drop_down;
      case TextRunDirection.bottomToTop:
        return Icons.arrow_drop_up;
      case TextRunDirection.none:
        return Icons.hide_source;
    }
  }
}
