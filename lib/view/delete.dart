import 'dart:convert';
import 'dart:developer';
import 'package:armiyaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostRequestExample extends StatefulWidget {
  const PostRequestExample({super.key});

  @override
  State<PostRequestExample> createState() => _PostRequestExampleState();
}

class _PostRequestExampleState extends State<PostRequestExample> {
  String responseText = "Henüz bir istek yapılmadı.";

  Future<void> makePostRequest() async {
    final String url = "https://$apiBaseUrl/randevu/qr.php";
    final Map<String, String> headers = {
      'accept': 'application/json, text/javascript, */*; q=0.01',
      'accept-language': 'tr-TR,tr;q=0.9,en-US;q=0.8,en;q=0.7',
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'cookie': 'PHPSESSID=0ms1fk84dssk9s3mtfmmdsjq24; language=tr',
      'origin': 'https://$apiBaseUrl',
      'referer': 'https://$apiBaseUrl/randevu/qr.php',
      'sec-ch-ua': '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '"Windows"',
      'sec-fetch-dest': 'empty',
      'sec-fetch-mode': 'cors',
      'sec-fetch-site': 'same-origin',
      'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
      'x-requested-with': 'XMLHttpRequest',
    };
    const Map<String, String> body = {
      'qrolustur': 'deger1',
      'id': '1',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Başarılı yanıt geldi, içeriği çöz ve ekranda göster
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          responseText = jsonEncode(jsonResponse); // JSON'u ekrana yazdır
        });
      } else {
        // Başarısız yanıt geldi
        setState(() {
          responseText = "Hata: ${response.statusCode} - ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      // İstek sırasında hata oluştu
      log("İstek sırasında hata oluştu: $e");
      setState(() {
        responseText = "İstek sırasında hata oluştu: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Request Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: makePostRequest,
              child: const Text("POST İsteği Gönder"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Gelen Yanıt:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(responseText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
