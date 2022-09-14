import 'package:flutter/material.dart';
import 'package:git_companion/common/dropdown/cool_dropdown.dart';
import 'package:git_companion/common/responsive.dart';

class CommonDropdown extends StatelessWidget {
  List<Map<String, String>> dropdownList;
  final Function(Map<String, String>) onCommandSelection;
  TextEditingController textController;
  CommonDropdown(
      {Key? key,
      required this.dropdownList,
      required this.onCommandSelection,
      required this.textController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CoolDropdown(
      resultWidth: Responsive.isMobile(context)
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width * 0.3,
      dropdownWidth: Responsive.isMobile(context)
          ? MediaQuery.of(context).size.width //- 100
          : MediaQuery.of(context).size.width * 0.3 - 20,
      isTriangle: false,
      gap: 0,
      resultBD: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 0.0,
              offset: const Offset(2.0, 2.0))
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      dropdownBD: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade300)),
      unselectedItemTS: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      dropdownList: dropdownList,
      resultTS: const TextStyle(
          fontFamily: 'IBMPlexMono',
          fontSize: 16.0,
          color: Color.fromRGBO(81, 81, 81, 1),
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold),
      onChange: (value) {
        onCommandSelection(value);
      },
      textController: textController,
    );
  }
}
