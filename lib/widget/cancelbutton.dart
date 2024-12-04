import 'package:flutter/material.dart';
import 'package:dialog_alert/dialog_alert.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialog Alert'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ElevatedButton(
              child: const Text(
                  'Alert dialog with Custom Button Title Text Style'),
              onPressed: () async {
                final result = await showDialogAlert(
                  context: context,
                  title: 'Success',
                  message: 'You have successfully uploaded',
                  actionButtonTitle: 'Submit',
                  cancelButtonTitle: 'Cancel',
                  actionButtonTextStyle: const TextStyle(
                    color: Colors.green,
                  ),
                  cancelButtonTextStyle: const TextStyle(
                    color: Colors.pink,
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
