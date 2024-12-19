import 'dart:async';
import 'dart:convert';
import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/model/qr_model.dart';
import 'package:armiyaapp/model/usermodel.dart';

import 'package:armiyaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'dart:math'; // Rastgele seçim için

class PrettyQrHomePage extends StatefulWidget {
  const PrettyQrHomePage({Key? key}) : super(key: key);

  @override
  State<PrettyQrHomePage> createState() => _PrettyQrHomePageState();
}

class _PrettyQrHomePageState extends State<PrettyQrHomePage> {
  late UserModel? user;
  Timer? _timer;
  double? _originalBrightness;
  String? currentQrCode;
  final String apiUrl = "https://$apiBaseUrl/api/randevu/olustur/index.php";
  List<String> qrCodes = [];
  double _progress = 1.0; // İlerleme durumu (0.0 - 1.0)

  @override
  void initState() {
    super.initState();
    _setBrightness(1.0);
    _getUserData().then((_) {
      _fetchQrCodes().then((_) {
        _updateQrCode();
        // QR kodunu her 100ms'de bir güncelleyen zamanlayıcı (ilerleme için)
        _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          setState(() {
            _progress += 0.02; // Her 100ms'de %2 artış
            if (_progress >= 1.0) {
              _progress = 0.0; // İlerleme sıfırlanır
              _updateQrCode(); // QR kodu güncellenir
            }
          });
        });
      });
    });
  }

  Future<void> _getUserData() async {
    try {
      user = await SharedDataService().getLoginData();
    } catch (e) {
      debugPrint("Kullanıcı verisi alınırken hata oluştu: $e");
    }
  }

  Future<void> _fetchQrCodes() async {
    if (user == null || user!.iD == null) return;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'id': user!.iD.toString(),
          'qrolustur': '1',
          'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        QR qrData = QR.fromJson(responseData);
        if (qrData.status == 'SUCCESS' && qrData.qrkodlar != null) {
          setState(() {
            qrCodes = qrData.qrkodlar!;
          });
        }
      } else {
        debugPrint("API hatası: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("QR kodları alınırken hata oluştu: $e");
    }
  }

  void _updateQrCode() {
    if (qrCodes.isNotEmpty) {
      Random random = Random();
      String selectedQrCode = qrCodes[random.nextInt(qrCodes.length)];
      setState(() {
        currentQrCode = selectedQrCode;
        print(currentQrCode);
        print(qrCodes);
      });
      _fetchQrCodes();
    }
  }

  Future<void> _setBrightness(double brightness) async {
    try {
      _originalBrightness = await ScreenBrightness().current;
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      debugPrint("Ekran parlaklığı ayarlanamadı: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (_originalBrightness != null) {
      ScreenBrightness().setScreenBrightness(_originalBrightness!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(right: 30, left: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              currentQrCode != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text(
                            "QR Kodunuz",
                            style: TextStyle(fontSize: 25, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            height: 16, // Kalınlık
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20), // Yuvarlatmak için
                              child: LinearProgressIndicator(
                                value: _progress, // İlerleme durumu
                                backgroundColor: const Color.fromARGB(255, 203, 203, 203),
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          PrettyQrView.data(
                            data: currentQrCode!,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Qr kod her 5 saniyede bir yenilenmektedir.Randevu saatiniz dışında giriş yapamazsınız.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    )
                  : const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}



















































// import 'dart:async';
// import 'dart:convert';
// import 'package:armiyaapp/data/app_shared_preference.dart';
// import 'package:armiyaapp/model/qr_model.dart';
// import 'package:armiyaapp/model/usermodel.dart';

// import 'package:armiyaapp/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pretty_qr_code/pretty_qr_code.dart';
// import 'package:screen_brightness/screen_brightness.dart';
// import 'dart:math'; // Rastgele seçim için

// class PrettyQrHomePage extends StatefulWidget {
//   const PrettyQrHomePage({Key? key}) : super(key: key);

//   @override
//   State<PrettyQrHomePage> createState() => _PrettyQrHomePageState();
// }

// class _PrettyQrHomePageState extends State<PrettyQrHomePage> {
//   late UserModel? user; // Kullanıcı modeli
//   Timer? _timer; // QR kodunun otomatik yenilenmesi için zamanlayıcı
//   double? _originalBrightness; // Ekran parlaklık değeri
//   String? currentQrCode; // Mevcut QR kodu
//   final String apiUrl = "https://$apiBaseUrl/api/randevu/olustur/index.php"; // API adresi
//   List<String> qrCodes = []; // QR kodlarının listesi

//   @override
//   void initState() {
//     super.initState();
//     _setBrightness(1.0); // Uygulama başlatıldığında ekran parlaklığını artır
//     _getUserData().then((_) {
//       _fetchQrCodes().then((_) {
//         // İlk QR kodunu hemen ayarla
//         _updateQrCode();

//         // QR kodunu her 5 saniyede bir yenileyen zamanlayıcı
//         _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
//           _updateQrCode(); // QR kodunu güncelle
//         });
//       }); // API'den QR kodlarını çek
//     }); // Kullanıcı verilerini al
//   }

//   // Kullanıcı verilerini SharedDataService'den al
//   Future<void> _getUserData() async {
//     try {
//       user = await SharedDataService().getLoginData();
//     } catch (e) {
//       debugPrint("Kullanıcı verisi alınırken hata oluştu: $e");
//     }
//   }

//   // API'den QR kodlarını çek ve parse et
//   Future<void> _fetchQrCodes() async {
//     if (user == null || user!.iD == null) return; // Kullanıcı giriş yapmamışsa durdur

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//         body: {
//           'id': user!.iD.toString(),
//           'qrolustur': '1',
//           'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
//         }, // Kullanıcı ID'sini gönderiyoruz
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         QR qrData = QR.fromJson(responseData); // JSON'u QR modeline dönüştür
//         if (qrData.status == 'SUCCESS' && qrData.qrkodlar != null) {
//           setState(() {
//             qrCodes = qrData.qrkodlar!; // QR kodlarını state'e at
//           });
//         }
//       } else {
//         debugPrint("API hatası: ${response.statusCode}");
//       }
//     } catch (e) {
//       debugPrint("QR kodları alınırken hata oluştu: $e");
//     }
//   }

//   // QR kodunu güncelleme fonksiyonu
//   void _updateQrCode() {
//     if (qrCodes.isNotEmpty) {
//       Random random = Random();
//       String selectedQrCode = qrCodes[random.nextInt(qrCodes.length)]; // Rastgele QR kodu seç
//       setState(() {
//         currentQrCode = selectedQrCode; // QR kodunu güncelle
//       });
//     }
//   }

//   // Ekran parlaklığını ayarlayan fonksiyon
//   Future<void> _setBrightness(double brightness) async {
//     try {
//       _originalBrightness = await ScreenBrightness().current; // Mevcut parlaklık
//       await ScreenBrightness().setScreenBrightness(brightness); // Yeni parlaklık
//     } catch (e) {
//       debugPrint("Ekran parlaklığı ayarlanamadı: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // Zamanlayıcıyı durdur
//     if (_originalBrightness != null) {
//       ScreenBrightness().setScreenBrightness(_originalBrightness!); // Parlaklığı eski haline getir
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(right: 30, left: 30),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "QR Kodunuz (Her 5 sn'de bir yenileniyor)",
//                 style: TextStyle(fontSize: 20, color: Colors.grey),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               currentQrCode != null
//                   ? Column(
//                       children: [
//                         if (_timer != null)
//                           Padding(
//                             padding: EdgeInsets.symmetric(vertical: 16),
//                             child: Container(
//                               height: 16,
//                               decoration: BoxDecoration(
//                                 color: Colors.blueGrey[100],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     flex: (_timer!.tick + 1) % 5 + 1,
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(flex: 4 - (_timer!.tick + 1) % 5, child: const SizedBox.shrink()),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         PrettyQrView.data(
//                           data: currentQrCode!, // QR kodu içeriği
//                         ),
//                       ],
//                     )
//                   : const CircularProgressIndicator(), // QR kodu yüklenirken göster
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
