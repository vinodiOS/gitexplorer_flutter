import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:git_companion/core/app_color.dart';
import 'package:git_companion/data/primary_options.dart';
import 'package:git_companion/provider/adaptive_mode.dart';
import 'package:git_companion/screens/dashboard/components/result.dart';

class DashboardProvider extends ChangeNotifier {
  late bool _isFastSpeed = false;
  late Result _result;

  List<Map<String, String>> get primaryCommands {
    return sortedPrimaryOptions;
  }

  bool get speed => _isFastSpeed;
  Result get initialResult => _result;

  bool darkMode(BuildContext context) {
    return AdaptiveTheme.of(context).mode.isDark;
  }

  void changeFastSpeed() {
    _isFastSpeed = !_isFastSpeed;
    notifyListeners();
  }

  void changeDarkMode(BuildContext context) {
    bool isDark = AdaptiveTheme.of(context).mode.isDark;
    isDark
        ? AdaptiveTheme.of(context).setLight()
        : AdaptiveTheme.of(context).setDark();
    final conColor = isDark ? boxDecorationLight : boxDecorationDark;
    _result = Result(
        commandText: "",
        noteText: null,
        conColor: conColor,
        isModeChanged: false,
        speedChanged: false);
    isDark
        ? AdaptiveTheme.of(context).setLight()
        : AdaptiveTheme.of(context).setDark();
    notifyListeners();
  }

  getInitialResult() async {
    final theme = await AdaptiveModel().getMode();
    final conColor = theme.isDark ? boxDecorationDark : boxDecorationLight;
    _result = Result(
        commandText: "",
        noteText: null,
        conColor: conColor,
        isModeChanged: false,
        speedChanged: false);
    notifyListeners();
  }
}
