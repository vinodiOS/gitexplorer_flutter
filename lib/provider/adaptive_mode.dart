import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class AdaptiveModel extends ChangeNotifier {
  AdaptiveThemeMode? _mode;
  AdaptiveThemeMode? get mode => _mode;

  Future<AdaptiveThemeMode?> getMode() async {
    _mode = await AdaptiveTheme.getThemeMode();
    return _mode;
  }
}
