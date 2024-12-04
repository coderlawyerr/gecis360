import 'dart:convert';
import 'package:armiyaapp/utils/constants.dart';
import 'package:http/http.dart' as http;

Future<String?> createAppointment({
  required String authorization,
  required String phpSessionId,
  required String kullaniciId,
  required String token,
  required String hizmetId,
  required String tesisId,
  required String baslangicTarihi,
  required String bitisTarihi,
}) async {
  final String apiUrl = 'https://$apiBaseUrl/api/randevu/olustur/index.php';

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Basic $authorization',
      'PHPSESSID': phpSessionId,
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'randevuekle': '1',
      'kullanici_id': kullaniciId,
      'token': token,
      'hizmetid': hizmetId,
      'tesisid': tesisId,
      'baslangictarihi': baslangicTarihi,
      'bitistarihi': bitisTarihi,
    },
  );

  if (response.statusCode == 200) {
    // Başarılı yanıt
    print('Randevu başarıyla oluşturuldu: ${response.body}');

    return response.body.toString();
  } else {
    return response.body.toString();
    // Hata durumu
    print('Randevu oluşturulurken hata oluştu: ${response.statusCode} - ${response.body}');
  }
}
