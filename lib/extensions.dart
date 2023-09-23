import 'package:flutter/material.dart';

extension ContextExt on BuildContext{

  get height {
    return MediaQuery.of(this).size.height;
  }

  get width {
    return MediaQuery.of(this).size.width;
  }
}

