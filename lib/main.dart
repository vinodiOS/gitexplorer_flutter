import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:git_companion/core/adaptive_theme.dart';
import 'package:git_companion/provider/adaptive_mode.dart';

import 'screens/dashboard/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveModel().getMode();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdaptiveModel()),
      ],
      child: GitCompanion(
        mode: savedThemeMode ?? AdaptiveThemeMode.light,
      )));
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
        home: Dashboard(),
      ),
    );
  }
}
