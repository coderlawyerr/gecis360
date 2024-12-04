import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MisafirAddProvider extends ChangeNotifier {
  List<Map<String, String>> misafirList = [];

  void loadMisafirler() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? misafirJson = prefs.getString('misafirBilgileri');
    if (misafirJson != null) {
      misafirList = List<Map<String, String>>.from(
        json.decode(misafirJson).map(
            (item) => Map<String, String>.from(item as Map<String, dynamic>)),
      );
    }
    notifyListeners();
  }

  void clearMisafirList() {
    misafirList.clear();
  }
}
