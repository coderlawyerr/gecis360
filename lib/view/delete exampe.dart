import 'package:armiyaapp/widget/uyari_widget.dart';
import 'package:flutter/material.dart';

class Delete extends StatefulWidget {
  const Delete({super.key});

  @override
  State<Delete> createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Text("data"),
                IptalEdilenRandevuCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
