import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:git_companion/responsive.dart';

class Header extends StatefulWidget {
  final Function modeSwitched;
  final Function(bool) speedChanged;
  const Header(
      {Key? key, required this.modeSwitched, required this.speedChanged})
      : super(key: key);
  @override
  HeaderState createState() => HeaderState();
}

class HeaderState extends State<Header> {
  bool isFastSpeed = false;
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    if (!Responsive.isMobile(context)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_textSpeedWidget(), _darkModeWidget()],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_textSpeedWidget(), _darkModeWidget()],
      );
    }
  }

  Widget _textSpeedWidget() {
    return Row(
      children: [
        Text(
          "Normal type speed",
          style: AdaptiveTheme.of(context).theme.textTheme.bodyText1,
        ),
        Material(
          color: Colors.transparent,
          child: Switch(
              value: isFastSpeed,
              activeColor: Colors.white,
              inactiveThumbColor: Colors.white,
              activeTrackColor: AdaptiveTheme.of(context).theme.primaryColor,
              inactiveTrackColor: AdaptiveTheme.of(context).theme.primaryColor,
              onChanged: (value) {
                setState(() {
                  isFastSpeed = !isFastSpeed;
                  widget.speedChanged(isFastSpeed);
                });
              }),
        ),
        Text(
          "Fast type speed",
          style: AdaptiveTheme.of(context).theme.textTheme.bodyText1,
        ),
      ],
    );
  }

  Widget _darkModeWidget() {
    return Row(
      children: [
        Text(
          "Light Mode",
          style: AdaptiveTheme.of(context).theme.textTheme.bodyText1,
        ),
        Material(
            color: Colors.transparent,
            child: Switch(
                value: isDarkMode || AdaptiveTheme.of(context).mode.isDark,
                activeColor: Colors.white,
                inactiveThumbColor: Colors.white,
                activeTrackColor: AdaptiveTheme.of(context).theme.primaryColor,
                inactiveTrackColor:
                    AdaptiveTheme.of(context).theme.primaryColor,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = !isDarkMode;
                    isDarkMode
                        ? AdaptiveTheme.of(context).setDark()
                        : AdaptiveTheme.of(context).setLight();
                  });
                  widget.modeSwitched();
                })),
        Text(
          "Dark Mode",
          style: AdaptiveTheme.of(context).theme.textTheme.bodyText1,
        ),
      ],
    );
  }
}
