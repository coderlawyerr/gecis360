import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/model/usermodel.dart';
import 'package:armiyaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:http/http.dart' as http;

class QRImageFetcher extends StatefulWidget {
  const QRImageFetcher({super.key});
  @override
  State createState() => _QRImageFetcherState();
}
class _QRImageFetcherState extends State<QRImageFetcher> {
  late final UserModel? user;
  Timer? _timer;
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  String? _imageUrl;
  final String apiUrl = "https://$apiBaseUrl/randevu/qr.php";
  double? _originalBrightness; // Ekran parlaklığını saklamak için değişken
  @override
  void initState() {
    super.initState();
    _setBrightness(1.0, true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _counter.value++;
      if (_counter.value > 5) {
        _counter.value = 0;
      }
      log('Counter: $_counter');
    });
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchImage();
    });
  }
  Future<void> _getOriginalBrightness() async {
    _originalBrightness = await ScreenBrightness().application; // Mevcut parlaklığı al
  }
  Future<void> _setBrightness(double brightness, isInitUser) async {
    if (isInitUser) {
      user = await SharedDataService().getLoginData();
    }
    await _getOriginalBrightness();
    try {
      await ScreenBrightness().setSystemScreenBrightness(brightness);
      _fetchImage();
    } catch (e) {
      print("Parlaklık ayarlanırken hata oluştu: $e");
    }
  }
  Future<void> _fetchImage() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'accept': 'application/json, text/javascript, ; q=0.01',
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
      },
      body: {'qrolustur': "true", 'id': user?.id?.toString()},
    );
    print('Response status: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          if (mounted)
            setState(() {
              _imageUrl = json["link"];
            });
        },
      );
    } else {
      print('Error: ${response.statusCode}');
    }
  }
  @override
  void dispose() {
    _timer?.cancel();
    _setBrightness(0.1, false); // Varsayılan parlaklık seviyesine geri dön
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('RANDEVU QR KODU')),
      body: Padding(
        padding: EdgeInsets.all(60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "RANDEVU İÇİN QR KODUNUZ",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            if (_imageUrl != null)
              ValueListenableBuilder(
                  valueListenable: _counter,
                  builder: (context, val, child) {
                    return LinearProgressIndicator(
                      value: 1 / 5 * val,
                      color: Colors.yellow,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5664D9)),
                    );
                  }),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: _imageUrl != null
                  ? Padding(
                      padding: const EdgeInsets.all(1),
                      child: Image.network(_imageUrl ?? ''),
                    )
                  : const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}


/*
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:http/http.dart' as http;

class QRImageFetcher extends StatefulWidget {
  const QRImageFetcher({super.key});

  @override
  State<QRImageFetcher> createState() => _QRImageFetcherState();
}

class _QRImageFetcherState extends State<QRImageFetcher> {
  Timer? _imageTimer;
  Timer? _progressTimer;
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  String? _imageUrl;

  final String apiUrl = "https://$apiBaseUrl/randevu/qr.php";
  double? _originalBrightness;
  Future<void> makePostRequest() async {
    const String url = "https://$apiBaseUrl/randevu/qr.php";
    const Map<String, String> headers = {
      'accept': 'application/json, text/javascript, ; q=0.01',
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
          final responseText = jsonEncode(jsonResponse); // JSON'u ekrana yazdır
          _imageUrl = jsonResponse["link"];
          setState(() {});
        });
      } else {
        // Başarısız yanıt geldi
        setState(() {});
      }
    } catch (e) {
      // İstek sırasında hata oluştu
      log("İstek sırasında hata oluştu: $e");
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeBrightness();
    _startProgressTimer();
    _startImageFetchTimer();
    makePostRequest();
  }

  Future<void> _initializeBrightness() async {
    try {
      _originalBrightness = await ScreenBrightness().current; // Mevcut parlaklığı al
      await ScreenBrightness().setApplicationScreenBrightness(1.0); // Parlaklığı maksimuma ayarla
    } catch (e) {
      log("Parlaklık ayarlanırken hata oluştu: $e");
    }
  }

  void _startProgressTimer() {
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return; // Widget hâlâ monte edilmiş mi kontrol et
      _counter.value++;
      if (_counter.value > 5) {
        _counter.value = 0;
      }
    });
  }

  void _startImageFetchTimer() {
    _imageTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchImage();
    });
  }

  Future<void> _fetchImage() async {


    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'accept': '',
          'accept-language': 'tr-TR,tr;q=0.9,en-TR;q=0.8,en;q=0.7,en-US;q=0.6',
          'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'cookie': 'PHPSESSID=6irfbeoeqsmdga2cv8h8n535lv',
          'origin': 'https://$apiBaseUrl',
          'referer': 'https://$apiBaseUrl/randevu/qr.php',
        },
        body: {
          'qrolustur': '1',
          'id': '1',
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return; // Widget hâlâ monte edilmiş mi tekrar kontrol et
        setState(() {
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);

            print(data["link"]);
            _imageUrl = data["link"];
          }
        });
      } else {
        log('API Hatası: ${response.statusCode}');
      }
    } catch (e) {
      log("Resim alınırken hata oluştu: $e");
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel(); // Zamanlayıcıları temizle
    _imageTimer?.cancel();
    if (_originalBrightness != null) {
      ScreenBrightness().setApplicationScreenBrightness(_originalBrightness!); // Parlaklığı geri yükle
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "RANDEVU İÇİN QR KODUNUZ",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 100),
            ValueListenableBuilder<int>(
              valueListenable: _counter,
              builder: (context, val, child) {
                return LinearProgressIndicator(
                  value: val / 5,
                  color: Colors.yellow,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5664D9)),
                );
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: _imageUrl != null
                  ? Padding(
                      padding: const EdgeInsets.all(1),
                      child: Image.network(_imageUrl!),
                    )
                  : const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}


*/