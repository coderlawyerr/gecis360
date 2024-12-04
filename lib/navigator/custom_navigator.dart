import 'package:flutter/material.dart';

class AppNavigator {
  // Singleton class
  AppNavigator._();

  static final AppNavigator _instance = AppNavigator._();

  static AppNavigator get instance => _instance;

  Future<dynamic> push(
      {required BuildContext context, required Widget routePage}) async {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => routePage));
  }

  Future<dynamic> pushReplacement(
      {required BuildContext context, required Widget routePage}) async {
    return await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => routePage));
  }

  static void pop({required BuildContext context, dynamic args}) {
   return  Navigator.pop(context, args);
  }




}
