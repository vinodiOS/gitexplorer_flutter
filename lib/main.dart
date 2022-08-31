import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import 'screens/dashboard/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(
    savedThemeMode: savedThemeMode,
  ));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({
    Key? key,
    this.savedThemeMode,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
          primaryColor: const Color.fromRGBO(0, 198, 173, 1),
          textTheme: const TextTheme(
              bodyText1: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color.fromRGBO(74, 74, 74, 1),
                  decoration: TextDecoration.none,
                  letterSpacing: 1.5)),
          brightness: Brightness.light,
          backgroundColor: const Color.fromRGBO(238, 240, 242, 1)),
      dark: ThemeData(
          primaryColor: const Color.fromRGBO(0, 198, 173, 1),
          textTheme: const TextTheme(
              bodyText1: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  letterSpacing: 1.5)),
          brightness: Brightness.dark,
          backgroundColor: const Color.fromRGBO(31, 37, 45, 1)),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Git Explorer',
        theme: theme,
        darkTheme: darkTheme,
        home: Dashboard(),
      ),
    );
  }
}
