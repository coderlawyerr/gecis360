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
      // Saniye sayacını artır.
      _counter.value++;

      // 5 saniyede bir resim değiştir.
      if (_counter.value % 5 == 0) {
        _fetchImage();
      }
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
      body: {'qrolustur': "true", 'id': user?.iD?.toString()},
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
                    print('val${val}');
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
