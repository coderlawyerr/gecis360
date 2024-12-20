import 'dart:convert';
import 'dart:developer';
import 'package:armiyaapp/model/cancelappointment.dart';
import 'package:armiyaapp/utils/constants.dart';
import 'package:http/http.dart' as http;

class CancaledAppointmentService {
  static Future<bool> CancaledAppointment(int randevuId) async {
    final String url = 'https://$apiBaseUrl/api/randevu/olustur/index.php';

    print(randevuId);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {'randevuiptalet': randevuId.toString(), 'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as'},
      );
      if (response.statusCode == 200) {
        // JSON kontrolü
        final body = response.body;

        // Düz metin işleme
        if (body == "KULLANICIYOK") {
          print('JSON Yanıt4: $body');
          return false;
        } else if (body == "OK") {
          print('JSON Yanıt5: $body');
          return true;
        } else if (body == "SUCCESS") {
          return true;
        } else if (body == "SUREGECTI") {
          print("SUREGECTI");
          return false;
        } else {
          print('JSON Yanıt6: $body');
          return false;
        }
      } else {
        print('Hata: HTTP ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Hata (Exception): $e');
      return false;
    }
  }
}
