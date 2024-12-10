import 'dart:math';

import 'package:armiyaapp/model/usermodel.dart';
import 'package:http/http.dart' as http;

class AuthService {
  UserModel? myusermodel;

  Future<http.Response> login(String email, String password, [String? marka_db_user]) async {
  final String baseUrl = 'https://${marka_db_user ?? "demo"}.gecis360.com/api/login/index.php';
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
          if (marka_db_user != null) 'db_user': marka_db_user,
          'token': "Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as",
        },
      );

      return response;
    } catch (e) {
      throw Exception('Login işlemi sırasında hata oluştu: $e');
    }
  }
  
}
