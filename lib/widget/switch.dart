import 'package:flutter/material.dart';

class SwitchWidget extends StatefulWidget {
  const SwitchWidget({super.key, required this.title});

  final String title;

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  bool state = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title),
        Switch(
          value: state,
          onChanged: (val) {
            setState(() {
              state = val;
            });
          },
          activeColor: Colors.blue, // Aktif olduğunda switch rengi
          inactiveThumbColor: Colors.grey, // İnaktif olduğunda switch rengi
          inactiveTrackColor:
              Colors.grey[300], // İnaktif olduğunda arka plan rengi
        ),
      ],
    );
  }
}
