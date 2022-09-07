import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:git_companion/core/app_color.dart';
import 'package:git_companion/common/responsive.dart';
import 'package:git_companion/provider/dashboard_provider.dart';
import 'package:git_companion/screens/dashboard/components/common_dropdown.dart';
import 'package:git_companion/screens/dashboard/components/header.dart';
import 'package:git_companion/screens/dashboard/components/title_text.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardModel = Provider.of<DashboardProvider>(context);

    return Consumer<DashboardProvider>(builder: ((context, value, child) {
      return Scaffold(
        backgroundColor: AdaptiveTheme.of(context).theme.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            primary: false,
            padding: Responsive.isMobile(context)
                ? const EdgeInsets.all(20)
                : const EdgeInsets.all(40),
            child: Column(
              children: [
                const Header(),
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
                              const DashboardTitle(),
                              CommonDropdown(
                                dropdownList: dashboardModel.primaryCommands,
                                onCommandSelection: (value) {
                                  context
                                      .read<DashboardProvider>()
                                      .primaryValue = value;
                                },
                                textController:
                                    dashboardModel.primaryTextController,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              if (value.isSecondaryAvailable)
                                CommonDropdown(
                                  dropdownList:
                                      dashboardModel.secondaryOptionsList,
                                  onCommandSelection: (value) {
                                    context
                                        .read<DashboardProvider>()
                                        .secondaryValue = value;
                                  },
                                  textController:
                                      dashboardModel.secondaryTextController,
                                ),
                              const SizedBox(
                                height: 15,
                              ),
                              if (value.isTertiaryAvailable)
                                CommonDropdown(
                                  dropdownList:
                                      dashboardModel.tertiaryOptionsList,
                                  onCommandSelection: (value) {
                                    context
                                        .read<DashboardProvider>()
                                        .tertiaryValue = value;
                                  },
                                  textController:
                                      dashboardModel.tertiaryTextController,
                                )
                            ],
                          ),
                          const SizedBox(height: defaultPadding),
                          if (Responsive.isMobile(context))
                            const SizedBox(height: defaultPadding),
                          if (Responsive.isMobile(context)) value.initialResult
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      const SizedBox(width: defaultPadding),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 5,
                        child: value.initialResult,
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }));
  }
}
