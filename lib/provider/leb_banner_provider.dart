import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_shader_mark_text/widget/banner_leb/dot_style.dart';
import 'package:test_shader_mark_text/widget/shader_text/text_run_direction.dart';

class LebBannerProvider extends ChangeNotifier {
  bool _isHorizontalView = false;
  String _textContent = "Hello";

  bool get isHorizontalView => _isHorizontalView;
  String get textContent => _textContent;

  // text run direction
  TextRunDirection _selectedTextRunDirection = TextRunDirection.none;
  TextRunDirection get selectedTextRunDirection => _selectedTextRunDirection;

  //Text shape
  DotStyle _selectedTextShape = DotStyle.none;
  DotStyle get selectedTextShape => _selectedTextShape;

  void toggleView() {
    _isHorizontalView = !_isHorizontalView;
    notifyListeners();
    SystemChrome.setPreferredOrientations([
      _isHorizontalView
          ? DeviceOrientation.landscapeRight
          : DeviceOrientation.portraitUp,
    ]);
  }

  void updateTextContent(String text) {
    _textContent = text;
    notifyListeners();
  }

  void updateTextRunDirection(TextRunDirection textRunDirection) {
    _selectedTextRunDirection = textRunDirection;
    notifyListeners();
  }

  void updateTextShape(DotStyle textShape) {
    _selectedTextShape = textShape;
    notifyListeners();
  }
}
