import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  get height {
    return MediaQuery.of(this).size.height;
  }

  get width {
    return MediaQuery.of(this).size.width;
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  void pop() {
    Navigator.pop(this);
  }
}
