import 'dart:convert';
import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/model/kayit_model.dart';
import 'package:armiyaapp/utils/constants.dart';
import 'package:http/http.dart' as http;

class KayitOlustur {
  Future<List<kayit>> kayitolustur() async {
    final user = await SharedDataService().getLoginData();
    final String url = 'https://$apiBaseUrl/api/genel/index.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          'kullanicigirisleri': user?.iD?.toString() ?? "",
          'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
        },
      );

      if (response.statusCode == 200) {
 
        final responseBody = utf8.decode(response.bodyBytes);
  
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Listeyi `kayit` modeline dönüştürüyoruz
        return jsonResponse.map((json) => kayit.fromJson(json)).toList();
      } else {
        throw Exception('Hata: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(' işlem sırasında hata oluştu: $e');
    }
  }
}
