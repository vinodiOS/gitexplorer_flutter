import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart'
import 'package:git_companion/data/primary_options.dart';
import 'package:git_companion/data/secondary_options.dart';
import 'package:git_companion/data/tertiary_options.dart';
import 'package:git_companion/responsive.dart';
import 'package:git_companion/screens/dashboard/components/common_dropdown.dart';
import 'package:git_companion/screens/dashboard/components/header.dart';
import 'package:git_companion/screens/dashboard/components/result.dart';

import '../../../constants.dart';

class Dashboard extends StatefulWidget {
  Dashboard({
    Key? key,
  }) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isSecondaryAvailable = false;
  bool _isTertiaryAvailable = false;
  List<Map<String, String>> secondaryOptionsList = [];
  List<Map<String, String>> tertiaryOptionsList = [];
  String recent = '';
  String commandText = '';
  String noteText = '';
  bool isNoteVisible = false;
  late Color conColor;
  bool isHighSpeed = false;
  late Result result;

  TextEditingController primaryTextController = TextEditingController();
  TextEditingController secondaryTextController = TextEditingController();
  TextEditingController tertiaryTextController = TextEditingController();

  @override
  void initState() {
    conColor = AdaptiveTheme.of(context).mode.isDark
        ? boxDecorationDark
        : boxDecorationLight;
    result = Result(
        commandText: "",
        noteText: null,
        conColor: conColor,
        isModeChanged: false,
        speedChanged: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).theme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Header(
                modeSwitched: () {
                  setState(() {
                    conColor = AdaptiveTheme.of(context).mode.isDark
                        ? boxDecorationDark
                        : boxDecorationLight;
                    result = Result(
                      commandText: result.commandText,
                      noteText: result.noteText,
                      conColor: conColor,
                      isModeChanged: true,
                      speedChanged: isHighSpeed,
                    );
                  });
                },
                speedChanged: (value) {
                  isHighSpeed = value;
                },
              ),
              const SizedBox(height: 50),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Git',
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text: ' Command ',
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color: AdaptiveTheme.of(context)
                                            .theme
                                            .primaryColor),
                                  ),
                                  const TextSpan(
                                      text: 'Explorer',
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Find the right commands you need\nwithout digging through the web.",
                              textAlign: TextAlign.start,
                              style: AdaptiveTheme.of(context)
                                  .theme
                                  .textTheme
                                  .bodyText1,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              "I want to:",
                              style: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AdaptiveTheme.of(context)
                                      .theme
                                      .primaryColor),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CommonDropdown(
                              dropdownList: primaryOptions,
                              onCommandSelection: (value) {
                                if (secondaryOptions[value['value']] != null) {
                                  if (recent == '' ||
                                      recent == value['value']) {
                                    setState(() {
                                      secondaryOptionsList =
                                          secondaryOptions[value['value']]!;
                                      _isSecondaryAvailable = true;
                                      recent = value['value']!;
                                      primaryTextController.text =
                                          value['label']!;
                                      _isTertiaryAvailable = false;
                                      tertiaryTextController.clear();
                                    });
                                    return;
                                  }
                                  if (recent != value['value']) {
                                    setState(() {
                                      secondaryOptionsList =
                                          secondaryOptions[value['value']]!;
                                      primaryTextController.text =
                                          value['label']!;
                                      recent = value['value']!;
                                      _isTertiaryAvailable = false;
                                      secondaryTextController.clear();
                                      tertiaryTextController.clear();
                                      result = Result(
                                          commandText: "",
                                          noteText: null,
                                          conColor: AdaptiveTheme.of(context)
                                                  .mode
                                                  .isLight
                                              ? boxDecorationLight
                                              : boxDecorationDark,
                                          isModeChanged: false,
                                          speedChanged: false);
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _isSecondaryAvailable = false;
                                  });
                                }
                              },
                              textController: primaryTextController,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            if (_isSecondaryAvailable)
                              CommonDropdown(
                                dropdownList: secondaryOptionsList,
                                onCommandSelection: (value) {
                                  if (tertiaryOptions[value['value']] != null) {
                                    setState(() {
                                      tertiaryOptionsList =
                                          tertiaryOptions[value['value']]!;
                                      secondaryTextController.text =
                                          value['label']!;
                                      _isTertiaryAvailable = true;
                                    });
                                  } else {
                                    setState(() {
                                      _isTertiaryAvailable = false;
                                      secondaryTextController.text =
                                          value['label']!;
                                      tertiaryTextController.clear();
                                      result = Result(
                                        commandText: value['usage']!,
                                        noteText: value['nb'],
                                        conColor: conColor,
                                        isModeChanged: false,
                                        speedChanged: isHighSpeed,
                                      );
                                    });
                                  }
                                },
                                textController: secondaryTextController,
                              ),
                            const SizedBox(
                              height: 15,
                            ),
                            if (_isTertiaryAvailable)
                              CommonDropdown(
                                dropdownList: tertiaryOptionsList,
                                onCommandSelection: (value) {
                                  setState(() {
                                    tertiaryTextController.text =
                                        value['label']!;
                                    result = Result(
                                      commandText: value['usage']!,
                                      noteText: value['nb'],
                                      conColor: conColor,
                                      isModeChanged: false,
                                      speedChanged: isHighSpeed,
                                    );
                                  });
                                },
                                textController: tertiaryTextController,
                              )
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context))
                          const SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context)) result
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    const SizedBox(width: defaultPadding),
                  // On Mobile means if the screen is less than 850 we dont want to show it
                  if (!Responsive.isMobile(context))
                    Expanded(
                      flex: 5,
                      child: result,
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
