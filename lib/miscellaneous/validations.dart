// ignore_for_file: constant_identifier_names

import 'dart:core';

enum ValidationType { all, email, code, password }

extension ValidationTypeExtension on ValidationType {
  RegExp get pattern {
    switch (this) {
      case ValidationType.code:
        return RegExp(r'\d{6,}');

      case ValidationType.email:
        return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

      case ValidationType.password:
        return RegExp(
            r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=!])(?=\S+$).{8,}$');

      default:
        return RegExp('.{3,}');
    }
  }

  String? matchesPattern(String value) {
    if (pattern.hasMatch(value)) return null;

    switch (this) {
      case ValidationType.code:
        return "Code format does not meet requirements.";

      case ValidationType.email:
        return "Email format does not meet requirements.";

      case ValidationType.password:
        return "Password format does not meet requirements.";

      default:
        return 'Content format does not meet requirements.';
    }
  }
}
