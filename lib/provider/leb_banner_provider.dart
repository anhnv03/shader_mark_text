import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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

  //text style
  TextStyle _textStyle = TextStyle(
    fontSize: 24,
    fontFamily: GoogleFonts.roboto().fontFamily,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
  );
  TextStyle get textStyleContent => _textStyle;

  String? _selectFontFamily = GoogleFonts.roboto().fontFamily;
  String? get selectFontFamily => _selectFontFamily;

  double _selectedTextSize = 24;
  double get selectedTextSize => _selectedTextSize;

  bool _activeItalic = false;
  bool get activeItalic => _activeItalic;

  bool _activeBold = true;
  bool get activeBold => _activeBold;

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

  void updateTextStyle(TextStyle textStyle) {
    _textStyle = textStyle;
    notifyListeners();
  }

  void updateFontFamily(String fontFamily) {
    _selectFontFamily = fontFamily;
    _textStyle = _textStyle.copyWith(fontFamily: fontFamily);
    notifyListeners();
  }

  void updateFontStyle(bool value) {
    _activeItalic = value;
    _textStyle = _textStyle.copyWith(
        fontStyle: value ? FontStyle.italic : FontStyle.normal);
    notifyListeners();
  }

  void updateFontWeight(bool value) {
    _activeBold = value;
    _textStyle = _textStyle.copyWith(
        fontWeight: value ? FontWeight.bold : FontWeight.normal);
    notifyListeners();
  }

  void updateTextSize(double size) {
    _selectedTextSize = size;
    _textStyle = _textStyle.copyWith(fontSize: size);
    notifyListeners();
  }
}
