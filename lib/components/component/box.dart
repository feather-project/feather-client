import 'package:flutter/material.dart';

class BoxComponent {
  static Widget get zero => const SizedBox(height: 0, width: 0);

  static Widget get smallWidth => const SizedBox(width: 10);
  static Widget get mediumWidth => const SizedBox(width: 20);
  static Widget get bigWidth => const SizedBox(width: 30);

  static Widget customWidth(final double width) {
    return SizedBox(width: width);
  }

  static Widget get smallHeight => const SizedBox(height: 10);
  static Widget get mediumHeight => const SizedBox(height: 20);
  static Widget get bigHeight => const SizedBox(height: 30);

  static Widget customHeight(final double height) {
    return SizedBox(height: height);
  }
}
