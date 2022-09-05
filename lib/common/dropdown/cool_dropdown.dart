library cool_dropdown;

import 'package:flutter/material.dart';
import 'package:git_companion/common/dropdown/drop_down_body.dart';
import 'package:git_companion/common/dropdown/utils/animation_util.dart';
import 'package:git_companion/common/dropdown/utils/extension_util.dart';

class CoolDropdown extends StatefulWidget {
  List dropdownList;
  Function onChange;
  Function? onOpen;
  String placeholder;
  late Map defaultValue;
  bool isTriangle;
  bool isAnimation;
  bool isResultIconLabel;
  bool isResultLabel;
  bool isDropdownLabel; // late
  bool resultIconRotation;
  late Widget resultIcon;
  double resultIconRotationValue;

  // size
  double resultWidth;
  double resultHeight;
  double? dropdownWidth; // late
  double dropdownHeight; // late
  double dropdownItemHeight;
  double triangleWidth;
  double triangleHeight;
  double iconSize;

  // align
  Alignment resultAlign;
  String dropdownAlign; // late
  Alignment dropdownItemAlign;
  String triangleAlign;
  double triangleLeft;
  bool dropdownItemReverse;
  bool resultReverse;
  MainAxisAlignment resultMainAxis;
  MainAxisAlignment dropdownItemMainAxis;

  // padding
  EdgeInsets resultPadding;
  EdgeInsets dropdownItemPadding;
  EdgeInsets dropdownPadding; // late
  EdgeInsets selectedItemPadding;

  // style
  late BoxDecoration resultBD;
  late BoxDecoration dropdownBD; // late
  late BoxDecoration selectedItemBD;
  late TextStyle selectedItemTS;
  late TextStyle unselectedItemTS;
  late TextStyle resultTS;
  late TextStyle placeholderTS;

  // gap
  double gap;
  double labelIconGap;
  double dropdownItemGap;
  double dropdownItemTopGap;
  double dropdownItemBottomGap;
  double resultIconLeftGap;

  // text controller
  TextEditingController textController;

  CoolDropdown(
      {required this.dropdownList,
      required this.onChange,
      this.onOpen,
      resultIcon,
      placeholderTS,
      this.dropdownItemReverse = false,
      this.resultReverse = false,
      this.resultIconRotation = true,
      this.isTriangle = true,
      this.isResultLabel = true,
      this.placeholder = '',
      this.resultWidth = 220,
      this.resultHeight = 50,
      this.dropdownWidth,
      this.dropdownHeight = 300,
      this.dropdownItemHeight = 40,
      this.resultAlign = Alignment.centerLeft,
      this.dropdownAlign = 'center',
      this.triangleAlign = 'center',
      this.dropdownItemAlign = Alignment.centerLeft,
      this.dropdownItemMainAxis = MainAxisAlignment.spaceBetween,
      this.resultMainAxis = MainAxisAlignment.spaceBetween,
      this.resultPadding = const EdgeInsets.only(left: 10, right: 10),
      this.dropdownItemPadding = const EdgeInsets.only(left: 10, right: 10),
      this.dropdownPadding = const EdgeInsets.only(left: 10, right: 10),
      this.selectedItemPadding = const EdgeInsets.only(left: 10, right: 10),
      resultBD,
      dropdownBD,
      selectedItemBD,
      selectedItemTS,
      unselectedItemTS,
      resultTS,
      this.labelIconGap = 0,
      this.dropdownItemGap = 0,
      this.dropdownItemTopGap = 5,
      this.dropdownItemBottomGap = 5,
      this.resultIconLeftGap = 10,
      this.gap = 30,
      this.triangleWidth = 20,
      this.triangleHeight = 20,
      this.triangleLeft = 0,
      this.isAnimation = true,
      this.isResultIconLabel = true,
      this.resultIconRotationValue = 0.5,
      this.isDropdownLabel = true,
      this.iconSize = 10,
      defaultValue,
      required this.textController}) {
    // 기본값 셋팅
    if (defaultValue != null) {
      print('.. $defaultValue');
      this.defaultValue = defaultValue;
    } else {
      this.defaultValue = {};
    }
    // label unique 체크
    for (var i = 0; i < dropdownList.length; i++) {
      if (dropdownList[i]['label'] == null) {
        throw '"label" must be initialized.';
      }
      for (var j = 0; j < dropdownList.length; j++) {
        if (i != j) {
          if (dropdownList[i]['label'] == dropdownList[j]['label']) {
            throw 'label is duplicated. Labels have to be unique.';
          }
        }
      }
    }
    // box decoration 셋팅
    this.resultBD = resultBD ??
        BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        );
    this.dropdownBD = dropdownBD ??
        BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 1),
            ),
          ],
        );
    this.selectedItemBD = selectedItemBD ??
        BoxDecoration(
          color: Color(0XFFEFFAF0),
          borderRadius: BorderRadius.circular(10),
        );
    // text style 셋팅
    this.selectedItemTS =
        selectedItemTS ?? TextStyle(color: Color(0xFF6FCC76), fontSize: 20);
    this.unselectedItemTS = unselectedItemTS != null
        ? unselectedItemTS
        : TextStyle(
            fontSize: 20,
            color: Colors.black,
          );
    this.resultTS = resultTS ??
        TextStyle(
          fontSize: 20,
          color: Colors.black,
        );
    this.placeholderTS = placeholderTS ??
        TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 20);
    // Icon Container 셋팅
    this.resultIcon = resultIcon ??
        Container(
          width: this.iconSize,
          height: this.iconSize,
          child: CustomPaint(
            size: Size(
                this.iconSize * 0.01, (this.iconSize * 0.01 * 1).toDouble()),
            painter: DropdownArrow(),
          ),
        );
  }

  @override
  _CoolDropdownState createState() => _CoolDropdownState();
}

class _CoolDropdownState extends State<CoolDropdown>
    with TickerProviderStateMixin {
  GlobalKey<DropdownBodyState> dropdownBodyChild = GlobalKey();
  GlobalKey inputKey = GlobalKey();
  Offset triangleOffset = Offset(0, 0);
  late OverlayEntry _overlayEntry;
  late Map selectedItem;
  late AnimationController rotationController;
  late AnimationController sizeController;
  late Animation<double> textWidth;
  AnimationUtil au = AnimationUtil();
  late bool isOpen = false;

  void openDropdown() {
    isOpen = true;
    if (widget.onOpen != null) {
      widget.onOpen!(isOpen);
    }
    this._overlayEntry = this._createOverlayEntry();
    Overlay.of(inputKey.currentContext!)!.insert(this._overlayEntry);
    rotationController.forward();
  }

  void closeDropdown() {
    isOpen = false;
    if (widget.onOpen != null) {
      widget.onOpen!(isOpen);
    }
    this._overlayEntry.remove();
    rotationController.reverse();
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (BuildContext context) => DropdownBody(
        key: dropdownBodyChild,
        inputKey: inputKey,
        onChange: widget.onChange,
        dropdownList: widget.dropdownList,
        dropdownItemReverse: widget.dropdownItemReverse,
        isTriangle: widget.isTriangle,
        resultWidth: widget.resultWidth,
        resultHeight: widget.resultHeight,
        dropdownWidth: widget.dropdownWidth,
        dropdownHeight: widget.dropdownHeight,
        dropdownItemHeight: widget.dropdownItemHeight,
        resultAlign: widget.resultAlign,
        dropdownAlign: widget.dropdownAlign,
        triangleAlign: widget.triangleAlign,
        dropdownItemAlign: widget.dropdownItemAlign,
        dropdownItemPadding: widget.dropdownItemPadding,
        dropdownPadding: widget.dropdownPadding,
        selectedItemPadding: widget.selectedItemPadding,
        resultBD: widget.resultBD,
        dropdownBD: widget.dropdownBD,
        selectedItemBD: widget.selectedItemBD,
        selectedItemTS: widget.selectedItemTS,
        unselectedItemTS: widget.unselectedItemTS,
        dropdownItemGap: widget.dropdownItemGap,
        dropdownItemTopGap: widget.dropdownItemTopGap,
        dropdownItemBottomGap: widget.dropdownItemBottomGap,
        gap: widget.gap,
        labelIconGap: widget.labelIconGap,
        triangleWidth: widget.triangleWidth,
        triangleHeight: widget.triangleHeight,
        triangleLeft: widget.triangleLeft,
        isResultLabel: widget.isResultLabel,
        closeDropdown: () {
          closeDropdown();
        },
        getSelectedItem: (selectedItem) async {
          sizeController = AnimationController(
            vsync: this,
            duration: au.isAnimation(
                status: widget.isAnimation,
                duration: Duration(milliseconds: 150)),
          );
          textWidth = CurvedAnimation(
            parent: sizeController,
            curve: Curves.fastOutSlowIn,
          );
          setState(() {
            this.selectedItem = selectedItem;
          });
          await sizeController.forward();
        },
        selectedItem: selectedItem,
        isAnimation: widget.isAnimation,
        dropdownItemMainAxis: widget.dropdownItemMainAxis,
        bodyContext: context,
        isDropdownLabel: widget.isDropdownLabel,
      ),
    );
  }

  @override
  void initState() {
    rotationController = AnimationController(
        duration: au.isAnimation(
            status: widget.isAnimation, duration: Duration(milliseconds: 150)),
        vsync: this);
    sizeController = AnimationController(
        vsync: this,
        duration: au.isAnimation(
            status: widget.isAnimation, duration: Duration(milliseconds: 150)));
    textWidth = CurvedAnimation(
      parent: sizeController,
      curve: Curves.fastOutSlowIn,
    );
    // placeholder 셋팅
    setDefaultValue();
    super.initState();
  }

  void setDefaultValue() {
    setState(() {
      sizeController = AnimationController(
        vsync: this,
        duration: au.isAnimation(status: false),
      );
      textWidth = CurvedAnimation(
        parent: sizeController,
        curve: Curves.fastOutSlowIn,
      );
      this.selectedItem = widget.defaultValue;
      sizeController.forward();
    });
  }

  RotationTransition rotationIcon() {
    return RotationTransition(
        turns: Tween(begin: 0.0, end: widget.resultIconRotationValue).animate(
            CurvedAnimation(parent: rotationController, curve: Curves.easeIn)),
        child: widget.resultIcon);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isOpen) {
          await dropdownBodyChild.currentState!.animationReverse();
          closeDropdown();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: GestureDetector(
        onTap: () {
          openDropdown();
        },
        child: Stack(
          children: [
            Container(
              key: inputKey,
              width: widget.resultWidth,
              height: widget.resultHeight,
              padding: widget.resultPadding,
              decoration: widget.resultBD,
              child: Align(
                alignment: widget.resultAlign,
                child: widget.isResultIconLabel
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Expanded(
                            child: SizeTransition(
                              sizeFactor: textWidth,
                              axisAlignment: -1,
                              child: Row(
                                mainAxisAlignment: widget.resultMainAxis,
                                children: [
                                  if (widget.isResultLabel)
                                    Flexible(
                                      child: IgnorePointer(
                                        child: TextField(
                                            controller: widget.textController,
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: '...',
                                                hintStyle: TextStyle(
                                                    fontFamily: 'IBMPlexMono',
                                                    fontSize: 14.0,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            style: widget.resultTS),
                                      ),
                                    ),
                                  if (widget.isResultLabel)
                                    SizedBox(
                                      width: widget.labelIconGap,
                                    ),
                                  if (selectedItem['icon'] != null)
                                    selectedItem['icon'] as Widget,
                                ].isReverse(widget.dropdownItemReverse),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widget.resultIconLeftGap,
                          ),
                          widget.resultIconRotation
                              ? rotationIcon()
                              : widget.resultIcon
                        ].isReverse(widget.resultReverse),
                      )
                    : rotationIcon(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class DropdownArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.4178592, size.height * 0.7748810);
    path_0.cubicTo(
        size.width * 0.4404533,
        size.height * 0.7974752,
        size.width * 0.4702912,
        size.height * 0.8087602,
        size.width * 0.5001371,
        size.height * 0.8087602);
    path_0.cubicTo(
        size.width * 0.5299831,
        size.height * 0.8087602,
        size.width * 0.5598290,
        size.height * 0.7974752,
        size.width * 0.5824151,
        size.height * 0.7748810);
    path_0.lineTo(size.width * 0.9639590, size.height * 0.3933371);
    path_0.cubicTo(
        size.width * 1.008325,
        size.height * 0.3489715,
        size.width * 1.013173,
        size.height * 0.2755667,
        size.width * 0.9704122,
        size.height * 0.2295878);
    path_0.cubicTo(
        size.width * 0.9252400,
        size.height * 0.1803824,
        size.width * 0.8486085,
        size.height * 0.1787691,
        size.width * 0.8018311,
        size.height * 0.2255546);
    path_0.lineTo(size.width * 0.5566105, size.height * 0.4699685);
    path_0.cubicTo(
        size.width * 0.5251593,
        size.height * 0.5014278,
        size.width * 0.4743325,
        size.height * 0.5014278,
        size.width * 0.4428733,
        size.height * 0.4699685);
    path_0.lineTo(size.width * 0.1984593, size.height * 0.2255546);
    path_0.cubicTo(
        size.width * 0.1516657,
        size.height * 0.1787691,
        size.width * 0.07503428,
        size.height * 0.1795757,
        size.width * 0.02987013,
        size.height * 0.2295878);
    path_0.cubicTo(
        size.width * -0.01288215,
        size.height * 0.2755667,
        size.width * -0.008848915,
        size.height * 0.3489715,
        size.width * 0.03632330,
        size.height * 0.3933371);
    path_0.lineTo(size.width * 0.4178592, size.height * 0.7748810);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.grey.withOpacity(0.7);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
