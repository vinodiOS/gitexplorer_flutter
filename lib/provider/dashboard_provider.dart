import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';

import 'package:git_companion/core/app_color.dart';
import 'package:git_companion/data/primary_options.dart';
import 'package:git_companion/data/secondary_options.dart';
import 'package:git_companion/data/tertiary_options.dart';
import 'package:git_companion/provider/adaptive_mode.dart';
import 'package:git_companion/screens/dashboard/components/result.dart';

class DashboardProvider extends ChangeNotifier {
  TextEditingController primaryTextController = TextEditingController();
  TextEditingController secondaryTextController = TextEditingController();
  TextEditingController tertiaryTextController = TextEditingController();

  late bool _isFastSpeed = false;
  late Result _result;
  late List<Map<String, String>> _secondaryOptionsList;
  late List<Map<String, String>> _tertiaryOptionsList;
  Color resultColor;

  late String _recent = '';
  String get recent => _recent;

  late bool _isSecondaryAvailable = false;
  bool get isSecondaryAvailable => _isSecondaryAvailable;

  late bool _isTertiaryAvailable = false;
  DashboardProvider(
    this.resultColor,
  ) {
    _result = Result(
        commandText: "",
        noteText: null,
        conColor: resultColor,
        isModeChanged: false,
        speedChanged: false);
  }
  bool get isTertiaryAvailable => _isTertiaryAvailable;

  List<Map<String, String>> get secondaryOptionsList => _secondaryOptionsList;
  List<Map<String, String>> get tertiaryOptionsList => _tertiaryOptionsList;

  set primaryValue(Map<String, String> selectedValue) {
    if (secondaryOptions[selectedValue['value']] != null) {
      if (recent == '' || recent == selectedValue['value']) {
        _secondaryOptionsList = secondaryOptions[selectedValue['value']]!;
        _isSecondaryAvailable = true;
        _recent = selectedValue['value']!;
        primaryTextController.text = selectedValue['label']!;
        _isTertiaryAvailable = false;
        tertiaryTextController.clear();
        notifyListeners();
        return;
      }
      if (recent != selectedValue['value']) {
        _secondaryOptionsList = secondaryOptions[selectedValue['value']]!;
        primaryTextController.text = selectedValue['label']!;
        _recent = selectedValue['value']!;
        _isTertiaryAvailable = false;
        secondaryTextController.clear();
        tertiaryTextController.clear();
        _result = Result(
            commandText: "",
            noteText: null,
            conColor: resultColor,
            isModeChanged: false,
            speedChanged: _isFastSpeed);
        notifyListeners();
      }
    } else {
      _isSecondaryAvailable = false;
      notifyListeners();
    }
  }

  set secondaryValue(Map<String, String> selectedValue) {
    if (tertiaryOptions[selectedValue['value']] != null) {
      _tertiaryOptionsList = tertiaryOptions[selectedValue['value']]!;
      secondaryTextController.text = selectedValue['label']!;
      _isTertiaryAvailable = true;
    } else {
      _isTertiaryAvailable = false;
      secondaryTextController.text = selectedValue['label']!;
      tertiaryTextController.clear();
      _result = Result(
        commandText: selectedValue['usage']!,
        noteText: selectedValue['nb'],
        conColor: resultColor,
        isModeChanged: false,
        speedChanged: _isFastSpeed,
      );
    }
    notifyListeners();
  }

  set tertiaryValue(Map<String, String> selectedValue) {
    tertiaryTextController.text = selectedValue['label']!;
    _result = Result(
      commandText: selectedValue['usage']!,
      noteText: selectedValue['nb'],
      conColor: resultColor,
      isModeChanged: false,
      speedChanged: _isFastSpeed,
    );
    notifyListeners();
  }

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
    resultColor = conColor;

    _result = Result(
        commandText: _result.commandText,
        noteText: _result.noteText,
        conColor: conColor,
        isModeChanged: true,
        speedChanged: false);
    isDark
        ? AdaptiveTheme.of(context).setLight()
        : AdaptiveTheme.of(context).setDark();
    notifyListeners();
  }

  getInitialResult() async {
    final theme = await AdaptiveModel().getMode();
    final conColor = theme.isDark ? boxDecorationDark : boxDecorationLight;
    resultColor = conColor;
    _result = Result(
        commandText: "",
        noteText: null,
        conColor: conColor,
        isModeChanged: false,
        speedChanged: false);
    notifyListeners();
  }
}
