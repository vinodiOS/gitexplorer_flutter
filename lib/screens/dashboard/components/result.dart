import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          isData: true,
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
            isData: false,
          )
      ],
    );
  }
}

class ResultContainer extends StatefulWidget {
  final Color backgroundColor;
  final String data;
  final bool isModeChanged;
  final bool isHighSpeed;
  final bool isData;
  const ResultContainer(
      {super.key,
      required this.backgroundColor,
      required this.data,
      required this.isModeChanged,
      required this.isHighSpeed,
      required this.isData});
  @override
  State<StatefulWidget> createState() {
    return ResultContainerState();
  }
}

class ResultContainerState extends State<ResultContainer>
    with TickerProviderStateMixin {
  late Animation _heartAnimation;
  late AnimationController _heartAnimationController;

  @override
  void initState() {
    _heartAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _heartAnimation = Tween(begin: 30.0, end: 40.0).animate(CurvedAnimation(
        curve: Curves.bounceOut, parent: _heartAnimationController));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _heartAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(10),
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
                  minHeight: 60,
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(16),
                child: DefaultTextStyle(
                  style: const TextStyle(
                      fontFamily: 'IBMPlexMono',
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                  child: widget.isModeChanged
                      ? Text(widget.data)
                      : AnimatedTextKit(
                          isRepeatingAnimation: false,
                          key: UniqueKey(),
                          animatedTexts: [
                            TyperAnimatedText(widget.data,
                                speed: widget.isHighSpeed
                                    ? const Duration(milliseconds: 20)
                                    : const Duration(milliseconds: 40)),
                          ],
                          onTap: () {},
                        ),
                ),
              ),
            ),
            if (widget.isData && widget.data.isNotEmpty)
              AnimatedBuilder(
                animation: _heartAnimationController,
                builder: (context, child) {
                  return Container(
                    height: 60,
                    padding: const EdgeInsets.only(right: 20),
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: widget.data));
                        _heartAnimationController.forward();
                        Timer(const Duration(milliseconds: 800), () {
                          _heartAnimationController.reset();
                        });
                      },
                      child: Icon(
                        Icons.content_copy,
                        color: Colors.white,
                        size: _heartAnimation.value,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
