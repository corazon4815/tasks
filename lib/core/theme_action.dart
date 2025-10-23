import 'package:flutter/material.dart';

class ThemeAction extends InheritedWidget {
  final VoidCallback? toggleThemeMode;
  const ThemeAction({required super.child, this.toggleThemeMode, super.key});

  static ThemeAction? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeAction>();
  }

  @override
  bool updateShouldNotify(ThemeAction oldWidget) =>
      toggleThemeMode != oldWidget.toggleThemeMode;
}
