import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:git_companion/screens/dashboard/components/result.dart';

class DashboardProvider extends ChangeNotifier {
  late bool _isFastSpeed = false;
  late bool _isDarkMode = false;

  bool get speed => _isFastSpeed;
  bool get darkMode => _isDarkMode;

  void changeFastSpeed() {
    _isFastSpeed = !_isFastSpeed;
    notifyListeners();
  }

  void changeDarkMode(BuildContext context) {
    _isDarkMode = !_isDarkMode;
    _isDarkMode
        ? AdaptiveTheme.of(context).setDark()
        : AdaptiveTheme.of(context).setLight();
    notifyListeners();
  }
}
