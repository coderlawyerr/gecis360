  import 'dart:convert';

import 'package:armiyaapp/utils/constants.dart';
import 'package:armiyaapp/view/appoinment/appointment_calender/model/randevu_model.dart';

/////
  Future<List<RandevuModel>> fetchRandevuList(int id) async {
    final url = 'https://$apiBaseUrl/api/randevu/olustur/index.php';
      List<RandevuModel>? aktifrandevular;
    const headers = {
      'Authorization': 'Basic cm9vdEBnZWNpczM2MC5jb206MTIzNDEyMzQ=',
      'PHPSESSID': '0ms1fk84dssk9s3mtfmmdsjq24',
    };
    final body = {'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as', 'aktifrandevular': '1', 'kullanici_id':id.toString() };

    try {
      var http;
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        aktifrandevular = [];
        List<dynamic> jsonData = json.decode(response.body);
        aktifrandevular?.addAll(jsonData.map((item) => RandevuModel.fromJson(item)).toList());

        return aktifrandevular;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('İstek sırasında hata oluştu: $e');
    }
  }