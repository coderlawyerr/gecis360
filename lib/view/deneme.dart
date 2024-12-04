import 'dart:convert';
import 'package:armiyaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiPostExample extends StatefulWidget {
  @override
  _ApiPostExampleState createState() => _ApiPostExampleState();
}

class _ApiPostExampleState extends State<ApiPostExample> {
  String result = "";

  Future<void> postData() async {
    final url = 'https://$apiBaseUrl/api/randevu/olustur/index.php';
    const headers = {
      'Authorization': 'Basic cm9vdEBnZWNpczM2MC5jb206MTIzNDEyMzQ=',
      // 'PHPSESSID': '0ms1fk84dssk9s3mtfmmdsjq24',
      //'accept': 'application/json',
      // 'Content-Type': 'application/x-www-form-urlencoded'
    };
    const body = {
      'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
      'aktifrandevular': '1',
      'kullanici_id': '1',
    };

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        // Başarılı yanıt
        setState(() {
          result = response.body;
        });
      } else {
        // Hata
        setState(() {
          result = "Hata: ${response.statusCode} - ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      // İstek sırasında hata oluştu
      setState(() {
        result = "Hata: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API İsteği Örneği'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: postData,
              child: Text('İstek Gönder'),
            ),
            SizedBox(height: 16),
            Text(
              result,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ApiPostExample(),
  ));
}
