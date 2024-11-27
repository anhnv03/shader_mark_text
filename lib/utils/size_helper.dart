import 'package:flutter/cupertino.dart';

extension SizeHelper on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;
  double get paddingBottom => MediaQuery.of(this).padding.bottom;
  double get paddingTop => MediaQuery.of(this).padding.top;
  double get paddingLeft => MediaQuery.of(this).padding.left;
  double get paddingRight => MediaQuery.of(this).padding.right;
}
