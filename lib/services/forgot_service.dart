import 'dart:developer';

import 'package:armiyaapp/utils/constants.dart';
import 'package:http/http.dart' as http;

class ForgotService {
  Future<http.Response> forgotPassword(String kullaniciadi, [String? marka_db_name]) async {
    final String url = 'https://$apiBaseUrl/api/genel/index.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          'sifremiUnuttum': '1',
          'kullaniciadi': kullaniciadi,
          if (marka_db_name != null) 'db_name': marka_db_name,
          'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
        },
      );
      log("https://$apiBaseUrl/api/genel/index.php");
      log({
        'sifremiUnuttum': '1',
        'kullaniciadi': kullaniciadi,
        if (marka_db_name != null) 'db_name': marka_db_name,
        'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
      }.toString());

      return response;
    } catch (e) {
      throw Exception(' işlemi sırasında hata oluştu: $e');
    }
  }
}
