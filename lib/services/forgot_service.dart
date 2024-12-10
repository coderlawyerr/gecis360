// import 'dart:convert';

// import 'package:armiyaapp/utils/constants.dart';
// import 'package:http/http.dart' as http;

// class ForgotService {
//   Future<bool> forgotPassword(String email) async {
//     final String url = 'https://$apiBaseUrl/api/genel/index.php';

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
//         },
//         body: {'sifremiUnuttum': '1', 'eposta': email, 'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as'},
//       );
//       print('buhata:${response.statusCode}');
//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);

//         print('servisten gelen :${jsonResponse.toString()}');
//         if (jsonResponse == "KULLANICIYOK") {
//           print('servisten gelen01 :$jsonResponse');
//           return false;
//         } else if (jsonResponse == "SUCCESS") {
//           print('servisten gelen2 :$jsonResponse');
//           return true;
//         } else {
//           print('servisten gelen 3:$jsonResponse');
//           return false;
//         }
//       } else {
//         print('servisten gelen 4 :');
//         return false;
//       }
//     } catch (e) {
//       print('servisten gelen 5 :$e');
//       return false;
//     }
//   }
// }

// import 'dart:convert';

// import 'package:armiyaapp/utils/constants.dart';
// import 'package:http/http.dart' as http;

// class ForgotService {
//   Future<bool> forgotPassword(String email) async {
//     final String url = 'https://$apiBaseUrl/api/genel/index.php';

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: <String, String>{
//           'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
//         },
//         body: {'sifremiUnuttum': '1', 'eposta': email, 'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as'},
//       );

//       print('HTTP Durum Kodu: ${response.statusCode}');
//       print('Gelen yanıt: ${response.body}');

//       if (response.statusCode == 200) {
//         // JSON kontrolü
//         final body = response.body;
//         if (body.startsWith('{') || body.startsWith('[')) {
//           final jsonResponse = jsonDecode(body);
//           print('JSON Yanıt: $jsonResponse');

//           if (jsonResponse == "KULLANICIYOK") {
//             print('JSON Yanıt1: $jsonResponse');
//             return false;
//           } else if (jsonResponse == "OK") {
//             print('JSON Yanıt2: $jsonResponse');
//             return true;
//           } else {
//             print('JSON Yanıt3: $jsonResponse');
//             return false;
//           }
//         } else {
//           // Düz metin işleme
//           if (body == "KULLANICIYOK") {
//             print('JSON Yanıt4: $body');
//             return false;
//           } else if (body == "OK") {
//             print('JSON Yanıt5: $body');
//             return true;
//           } else {
//             print('JSON Yanıt6: $body');
//             return false;
//           }
//         }
//       } else {
//         print('Hata: HTTP ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       print('Hata (Exception): $e');
//       return false;
//     }
//   }
// }

import 'dart:convert';

import 'package:armiyaapp/utils/constants.dart';
import 'package:http/http.dart' as http;

class ForgotService {
  Future<bool> forgotPassword(String email) async {
    final String url = 'https://$apiBaseUrl/api/genel/index.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {'sifremiUnuttum': '1', 'eposta': email, 'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as'},
      );

      print('HTTP Durum Kodu: ${response.statusCode}');
      print('Gelen yanıt: ${response.body}');

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
