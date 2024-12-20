import 'dart:developer';

import 'package:armiyaapp/model/usermodel.dart';
import 'package:http/http.dart' as http;

class AuthService {
  UserModel? myusermodel;

  Future<http.Response> login(String email, String password, [String? dbName, String? dbUser]) async {
    final String baseUrl = 'https://${dbUser ?? "demo"}.gecis360.com/api/login/index.php';
    final String url = baseUrl;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          'kullaniciadi': email,
          'sifre': password,
          if (dbName != null) 'db_name': dbName, ////////////////////
          'token': "Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as",
        },
      );

      return response;
    } catch (e) {
      log({
        'kullaniciadi': email,
        'sifre': password,
        'db_name': dbName,
        'token': "Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as",
      }.toString());
      throw Exception('Login işlemi sırasında hata oluştu: $e');
    }
  }
}
