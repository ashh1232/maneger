import 'dart:ui';

import 'package:flutter/material.dart';

class InputInInputWidget extends StatelessWidget {
  final String lText;
  final TextEditingController mycontroller;
  const InputInInputWidget({
    super.key,
    required this.lText,
    required this.mycontroller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
          color: Theme.of(context).primaryColor.withValues(
            alpha: .2,
            blue: .1,
            green: .1,
            red: .2,
            colorSpace: ColorSpace.sRGB,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextFormField(
          controller: mycontroller,
          style: TextStyle(
            color:
                Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
          ),
          decoration: InputDecoration(
            labelText: lText,
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            border: InputBorder.none, // Remove default underline
            enabledBorder:
                InputBorder.none, // Remove default outline when focused
            focusedBorder: InputBorder.none, // Remove default focus indicator
          ),
        ),
      ),
    );
  }
}
