import 'package:flutter/material.dart';

class CustomThemeTextField extends StatelessWidget {
  /// The controller for the text field.
  final TextEditingController controller;

  /// The label text for the text field.
  final String? labelText;

  /// The primary color of the text field.
  final Color? color;

  /// The color of the text field when it has focus.
  final Color? focusColor;

  /// Whether the text is obscure.
  /// Often set true for password input.
  final bool obscureText;

  const CustomThemeTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.color,
    this.focusColor,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    /// If the color is not provided, use the primary color from the theme
    final actualColor = color ?? Theme.of(context).primaryColor;

    /// If the focusColor is not provided, use the focus color from the theme
    final actualFocusColor = focusColor ?? Theme.of(context).focusColor;

    return TextField(
      controller: controller,
      cursorColor: actualFocusColor,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: actualColor,
        ),
        floatingLabelStyle: TextStyle(
          color: actualFocusColor,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: actualFocusColor,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
