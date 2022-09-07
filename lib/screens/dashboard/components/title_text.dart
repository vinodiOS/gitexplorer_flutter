import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:git_companion/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

class DashboardTitle extends StatelessWidget {
  const DashboardTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    color: AdaptiveTheme.of(context).theme.primaryColor),
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
        Consumer<DashboardProvider>(builder: ((context, value, child) {
          return Text(
              "Find the right commands you need\nwithout digging through the web.",
              textAlign: TextAlign.start,
              style: AdaptiveTheme.of(context).theme.textTheme.bodyText1);
        })),
        const SizedBox(
          height: 40,
        ),
        Text(
          "I want to:",
          style: TextStyle(
              letterSpacing: 1,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AdaptiveTheme.of(context).theme.primaryColor),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
