import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:git_companion/common/responsive.dart';
import 'package:git_companion/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!Responsive.isMobile(context)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_textSpeedWidget(context), _darkModeWidget(context)],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_textSpeedWidget(context), _darkModeWidget(context)],
      );
    }
  }

  Widget _textSpeedWidget(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    return Row(
      children: [
        Text(
          "Normal type speed",
          style: AdaptiveTheme.of(context).theme.textTheme.bodyText1,
        ),
        Material(
          color: Colors.transparent,
          child: Switch(
              value: provider.speed, //isFastSpeed,
              activeColor: Colors.white,
              inactiveThumbColor: Colors.white,
              activeTrackColor: AdaptiveTheme.of(context).theme.primaryColor,
              inactiveTrackColor: AdaptiveTheme.of(context).theme.primaryColor,
              onChanged: (value) {
                provider.changeFastSpeed();
                /*
                setState(() {
                  isFastSpeed = !isFastSpeed;
                  widget.speedChanged(isFastSpeed);
                });*/
              }),
        ),
        Text(
          "Fast type speed",
          style: AdaptiveTheme.of(context).theme.textTheme.bodyText1,
        ),
      ],
    );
  }

  Widget _darkModeWidget(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    return Row(
      children: [
        Text(
          "Light Mode",
          style: AdaptiveTheme.of(context).theme.textTheme.bodyText1,
        ),
        Material(
            color: Colors.transparent,
            child: Switch(
                value:
                    provider.darkMode || AdaptiveTheme.of(context).mode.isDark,
                activeColor: Colors.white,
                inactiveThumbColor: Colors.white,
                activeTrackColor: AdaptiveTheme.of(context).theme.primaryColor,
                inactiveTrackColor:
                    AdaptiveTheme.of(context).theme.primaryColor,
                onChanged: (value) {
                  provider.changeDarkMode(context);
                  /*
                  setState(() {
                    isDarkMode = !isDarkMode;
                    isDarkMode
                        ? AdaptiveTheme.of(context).setDark()
                        : AdaptiveTheme.of(context).setLight();
                  });
                  widget.modeSwitched();*/
                })),
        Text(
          "Dark Mode",
          style: AdaptiveTheme.of(context).theme.textTheme.bodyText1,
        ),
      ],
    );
  }
}
