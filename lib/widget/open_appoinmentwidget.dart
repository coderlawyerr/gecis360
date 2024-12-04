import 'package:flutter/material.dart';

class OpenAppointmentWidget extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsets padding;

  const OpenAppointmentWidget({
    super.key,
    required this.text,
    this.textColor = Colors.black,
    this.borderColor = Colors.grey,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderColor),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
