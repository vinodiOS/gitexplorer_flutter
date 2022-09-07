import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:git_companion/core/app_color.dart';
import 'package:git_companion/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

import 'package:git_companion/core/adaptive_theme.dart';
import 'package:git_companion/provider/adaptive_mode.dart';
import 'package:window_size/window_size.dart';

import 'screens/dashboard/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final savedThemeMode = await AdaptiveModel().getMode();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdaptiveModel()),
        ChangeNotifierProvider(
            create: (context) => DashboardProvider(savedThemeMode.isDark
                ? boxDecorationDark
                : boxDecorationLight)),
      ],
      child: GitCompanion(
        mode: savedThemeMode,
      )));
}

const double windowWidth = 400;
const double windowHeight = 800;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Git Explorer');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

@immutable
class GitCompanion extends StatelessWidget {
  final AdaptiveThemeMode mode;
  const GitCompanion({
    Key? key,
    required this.mode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: lightTheme,
      dark: darkTheme,
      initial: mode,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Git Explorer",
        theme: theme,
        darkTheme: darkTheme,
        home: const Dashboard(),
      ),
    );
  }
}
