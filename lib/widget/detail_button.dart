import 'package:flutter/material.dart';

class DetailButton extends StatelessWidget {
  final String proId;
  final Map<String, dynamic> data;

  final Color? bColor;
  final String buttonText;
  const DetailButton({
    super.key,
    // required this.controller,
    required this.buttonText, // Use named parameter for better readability
    this.bColor = Colors.blue,
    required this.proId,
    required this.data, // Default color if not provided
  });

  // final DetailController controller;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          bColor ?? Theme.of(context).primaryColor,
        ),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0), // Rounded corners
            side: BorderSide(
              width: 3,
              color: Colors.grey.withValues(),
            ), // Border
          ),
        ),
      ),
      onPressed: () {
        // controller.updateData(proId, data);
        // controller.toggleH();
      },
      child: Text(buttonText),
    );
  }
}
