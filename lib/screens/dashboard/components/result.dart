import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final String commandText;
  final String? noteText;
  final Color conColor;
  final bool isModeChanged;
  final bool speedChanged;
  const Result(
      {super.key,
      required this.commandText,
      this.noteText,
      required this.conColor,
      required this.isModeChanged,
      required this.speedChanged});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Usage",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        ResultContainer(
          backgroundColor: conColor,
          data: commandText,
          isModeChanged: isModeChanged,
          isHighSpeed: speedChanged,
        ),
        const SizedBox(
          height: 30,
        ),
        if (noteText != null)
          const Text(
            "Note",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        const SizedBox(
          height: 15,
        ),
        if (noteText != null)
          ResultContainer(
            backgroundColor: conColor,
            data: noteText!,
            isModeChanged: isModeChanged,
            isHighSpeed: speedChanged,
          )
      ],
    );
  }
}

class ResultContainer extends StatelessWidget {
  final Color backgroundColor;
  final String data;
  final bool isModeChanged;
  final bool isHighSpeed;
  const ResultContainer(
      {super.key,
      required this.backgroundColor,
      required this.data,
      required this.isModeChanged,
      required this.isHighSpeed});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        //border: Border.all(color: Colors.grey.shade300)
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IntrinsicHeight(
                child: Container(
                    alignment: Alignment.center,
                    width: 10,
                    decoration: BoxDecoration(
                        color: AdaptiveTheme.of(context).theme.primaryColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))))),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 80,
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(16),
                child: DefaultTextStyle(
                  style: const TextStyle(
                      fontFamily: 'IBMPlexMono',
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                  child: isModeChanged
                      ? Text(data)
                      : AnimatedTextKit(
                          isRepeatingAnimation: false,
                          key: UniqueKey(),
                          animatedTexts: [
                            TyperAnimatedText(data,
                                speed: isHighSpeed
                                    ? const Duration(milliseconds: 20)
                                    : const Duration(milliseconds: 40)),
                          ],
                          onTap: () {},
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
