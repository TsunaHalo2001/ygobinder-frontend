import 'package:flutter/material.dart';

/// Accent colors that stay readable in both light and dark themes.

bool _isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

Color getThemeGreen(BuildContext context) => _isDark(context) ? Colors.greenAccent : Colors.green.shade800;

Color getThemeAmber(BuildContext context) => _isDark(context) ? Colors.amber : Colors.amber.shade900;

Color getThemeOrange(BuildContext context) => _isDark(context) ? Colors.orangeAccent : Colors.orange.shade800;

Color getThemeRed(BuildContext context) => _isDark(context) ? Colors.redAccent : Colors.red.shade800;

/// Darkens light accent colors when the light theme is active.
Color getThemeAccent(BuildContext context, Color baseColor) {
  if (!_isDark(context)) {
    if (baseColor == Colors.tealAccent) return Colors.teal.shade800;
    if (baseColor == Colors.amber) return Colors.amber.shade900;
  }
  return baseColor;
}
