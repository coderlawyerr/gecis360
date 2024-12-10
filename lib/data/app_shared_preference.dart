import 'dart:convert';
import 'dart:developer';

import 'package:armiyaapp/model/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedDataService {
  // Bu bizim kullanıcımızın giriş bilgilerini tutan keyimiz olsun
  String userLoginKey = "loginKey";

// Bu function bizim kullanıcı bilgilerimizi tutatacak
  Future<void> saveLoginData(String loginData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userLoginKey, loginData);
  }

// Buda kaydettiğimiz bilgileri çekeceğimiz yer
  Future<UserModel?> getLoginData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final modelData = prefs.getString(userLoginKey);

    log(modelData.toString());
    if (modelData == null || modelData.isEmpty) {
      return null;
    }

    Map<String, dynamic> jsonData = jsonDecode(modelData);

    return UserModel.fromJson(jsonData);
  }

// Buda kullanıcı çıkış yapacağı zaman kullanacağımız function

  Future<bool> removeUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.remove(userLoginKey);
  }

  ////////////check box
  static Future<bool> bildirimOnayGetir() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('BildirimOnay') == null) {
      await prefs.setBool('BildirimOnay', false);
    }
    var bildirimOnay = prefs.getBool('BildirimOnay');
    return bildirimOnay!;
  }

  static Future<void> bildirimOnayGuncelle(bool bildirimOnay) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('BildirimOnay', bildirimOnay);
  }

  ////////////eposta ve sıfre kaydet

  static Future<void> loginbilgikaydet(String mail, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("loginbilgikaydet :${mail},${password}");
    await prefs.setString('mail', mail);
    await prefs.setString('password', password);
  }

  static Future<String> passwordgetir() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('password') == null) {
      await prefs.setString('password', "");
    }
    var password = prefs.getString('password');
    print("passworddan getılen deger :${password}");
    return password!;
  }

  static Future<String> mailgetir() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('mail') == null) {
      await prefs.setString('mail', "");
    }
    var mail = prefs.getString('mail');
    print("passwmailden  getılen deger :${mail}");
    return mail!;
  }

  getUserId() {}
}
