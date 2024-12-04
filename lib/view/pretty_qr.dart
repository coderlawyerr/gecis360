// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:armiyaapp/model/usermodel.dart';
// import 'package:armiyaapp/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pretty_qr_code/pretty_qr_code.dart';
// import 'package:screen_brightness/screen_brightness.dart';

// class PrettyQrHomePage extends StatefulWidget {
//   const PrettyQrHomePage({Key? key}) : super(key: key);

//   @override
//   State<PrettyQrHomePage> createState() => _PrettyQrHomePageState();
// }

// class _PrettyQrHomePageState extends State<PrettyQrHomePage> {
//   late final UserModel? user; // Kullanıcı modelini tanımlıyoruz
//   Timer? _timer; // QR kodunun her 5 saniyede bir yenilenmesini sağlayacak zamanlayıcı
//   final String token = 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as'; // API için geçerli token
//   double? _originalBrightness; // Ekran parlaklığını saklamak için değişken
//   String? currentQrCode; // Şu anki QR kodu
//   final String apiUrl = "https://$apiBaseUrl/api/randevu/olustur/index.php"; // API URL'si

//   @override
//   void initState() {
//     super.initState();
//     log("Uygulama başlatıldı.");
//     _setBrightness(1.0); // Uygulama başlatıldığında ekran parlaklığını artır
//     // QR kodunu her 5 saniyede bir güncelleyen bir zamanlayıcı başlatıyoruz
//     _timer = Timer.periodic(const Duration(seconds: 5), (_) {
//       log("5 saniyelik periyot başladı.");
//       _sendQrCodeToApi();
//     });
//   }

//   // Ekran parlaklığını ayarlayan fonksiyon
//   Future<void> _setBrightness(double brightness) async {

//     try {
//       log("Ekran parlaklığı ayarlanıyor...");
//       _originalBrightness = await ScreenBrightness().current; // Mevcut parlaklık değerini al
//       await ScreenBrightness().setScreenBrightness(brightness); // Yeni parlaklık değeri ayarla
//       log("Ekran parlaklığı başarıyla ayarlandı.");
//     } catch (e) {
//       log("Parlaklık ayarlanırken hata oluştu: $e"); // Hata durumunda loglama
//     }
//   }

//   // QR kodu ve kullanıcı ID'sini API'ye gönderen fonksiyon
//   Future<void> _sendQrCodeToApi() async {
//     log("QR kodu ve kullanıcı ID'si gönderilmeye çalışılıyor...");
//     if (user != null && user!.id != null && currentQrCode != null) {
//       try {
//         final response = await http.post(
//           Uri.parse(apiUrl),
//           headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//           body: {
//             'token': token,
//             'id': user!.id.toString(), // Kullanıcı ID'sini gönderiyoruz
//             'qr_code': currentQrCode!, // QR kodunu da göndermeliyiz
//           },
//         );
//         log("API isteği gönderildi, yanıt bekleniyor...");
//         if (response.statusCode == 200) {
//           final Map<String, dynamic> responseData = jsonDecode(response.body);
//           if (responseData['status'] == 'SUCCESS') {
//             log("QR Kodu ve Kullanıcı ID'si başarıyla gönderildi.");
//           } else {
//             log("API yanıtı başarılı değil: ${responseData['status']}");
//           }
//         } else {
//           log("API hatası: ${response.statusCode}");
//         }
//       } catch (e) {
//         log("QR kodu ve ID gönderilirken hata oluştu: $e");
//       }
//     } else {
//       log("Kullanıcı ID'si veya QR kodu mevcut değil.");
//     }
//   }

//   @override
//   void dispose() {
//     log("PrettyQrHomePage sayfası kapatılıyor.");
//     _timer?.cancel(); // Zamanlayıcıyı durdur
//     if (_originalBrightness != null) {
//       // Parlaklık değerini eski haline getir
//       ScreenBrightness().setScreenBrightness(_originalBrightness!);
//       log("Ekran parlaklığı eski haline getirildi.");
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     log("Widget build fonksiyonu çalıştı.");
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(30),
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
//               // QR kodu kütüphanesini kullanarak QR kodunu göster
//               currentQrCode != null
//                   ? PrettyQrView.data(
//                       data: currentQrCode!, // QR kodunun içeriği olarak API'den alınan değeri kullanıyoruz
//                       errorCorrectLevel: QrErrorCorrectLevel.H, // Hata düzeltme seviyesi
//                       decoration: const PrettyQrDecoration(), // QR dekorasyonu
//                     )
//                   : const CircularProgressIndicator(), // QR kodu yüklenirken gösterilecek animasyon
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:armiyaapp/model/usermodel.dart';
// import 'package:armiyaapp/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pretty_qr_code/pretty_qr_code.dart';
// import 'package:screen_brightness/screen_brightness.dart';
// import 'package:armiyaapp/data/app_shared_preference.dart'; // SharedDataService eklenmeli

// class PrettyQrHomePage extends StatefulWidget {
//   const PrettyQrHomePage({Key? key}) : super(key: key);

//   @override
//   State<PrettyQrHomePage> createState() => _PrettyQrHomePageState();
// }

// class _PrettyQrHomePageState extends State<PrettyQrHomePage> {
//   late UserModel? user; // Kullanıcı modelini tanımlıyoruz
//   Timer? _timer; // QR kodunun her 5 saniyede bir yenilenmesini sağlayacak zamanlayıcı
//   final String token = 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as'; // API için geçerli token
//   double? _originalBrightness; // Ekran parlaklığını saklamak için değişken
//   String? currentQrCode; // Şu anki QR kodu
//   final String apiUrl = "https://$apiBaseUrl/api/randevu/olustur/index.php"; // API URL'si

//   @override
//   void initState() {
//     super.initState();

//     _setBrightness(1.0); // Uygulama başlatıldığında ekran parlaklığını artır
//     _getUserData(); // Kullanıcı verilerini al
//     // QR kodunu her 5 saniyede bir güncelleyen bir zamanlayıcı başlatıyoruz
//     _timer = Timer.periodic(const Duration(seconds: 5), (_) {
//       _sendQrCodeToApi();
//     });
//   }

//   // Kullanıcı verilerini almak için SharedDataService'ı kullanıyoruz
//   Future<void> _getUserData() async {
//     try {
//       user = await SharedDataService().getLoginData();
//     } catch (e) {}
//   }

//   // Ekran parlaklığını ayarlayan fonksiyon
//   Future<void> _setBrightness(double brightness) async {
//     try {
//       _originalBrightness = await ScreenBrightness().current; // Mevcut parlaklık değerini al
//       await ScreenBrightness().setScreenBrightness(brightness); // Yeni parlaklık değeri ayarla
//     } catch (e) {}
//   }

//   // QR kodu ve kullanıcı ID'sini API'ye gönderen fonksiyon
//   Future<void> _sendQrCodeToApi() async {
//     if (user != null && user!.id != null && currentQrCode != null) {
//       try {
//         final response = await http.post(
//           Uri.parse(apiUrl),
//           headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//           body: {
//             'token': token,
//             'id': user!.id.toString(), // Kullanıcı ID'sini gönderiyoruz
//             'qr_code': currentQrCode!, // QR kodunu da göndermeliyiz
//           },
//         );

//         if (response.statusCode == 200) {
//           final Map<String, dynamic> responseData = jsonDecode(response.body);
//           if (responseData['status'] == 'SUCCESS') {
//           } else {}
//         } else {}
//       } catch (e) {}
//     } else {}
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // Zamanlayıcıyı durdur
//     if (_originalBrightness != null) {
//       // Parlaklık değerini eski haline getir
//       ScreenBrightness().setScreenBrightness(_originalBrightness!);
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(30),
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
//               // QR kodu kütüphanesini kullanarak QR kodunu göster
//               currentQrCode != null
//                   ? PrettyQrView.data(
//                       data: currentQrCode!, // QR kodunun içeriği olarak API'den alınan değeri kullanıyoruz
//                       errorCorrectLevel: QrErrorCorrectLevel.H, // Hata düzeltme seviyesi
//                       decoration: const PrettyQrDecoration(), // QR dekorasyonu
//                     )
//                   : const CircularProgressIndicator(), // QR kodu yüklenirken gösterilecek animasyon
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:armiyaapp/model/usermodel.dart';
// import 'package:armiyaapp/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pretty_qr_code/pretty_qr_code.dart';
// import 'package:screen_brightness/screen_brightness.dart';
// import 'package:armiyaapp/data/app_shared_preference.dart'; // SharedDataService eklenmeli

// class PrettyQrHomePage extends StatefulWidget {
//   const PrettyQrHomePage({Key? key}) : super(key: key);

//   @override
//   State<PrettyQrHomePage> createState() => _PrettyQrHomePageState();
// }

// class _PrettyQrHomePageState extends State<PrettyQrHomePage> {
//   late UserModel? user; // Kullanıcı modelini tanımlıyoruz
//   Timer? _timer; // QR kodunun her 5 saniyede bir yenilenmesini sağlayacak zamanlayıcı
//   final String token = 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as'; // API için geçerli token
//   double? _originalBrightness; // Ekran parlaklığını saklamak için değişken
//   String? currentQrCode; // Şu anki QR kodu
//   final String apiUrl = "https://$apiBaseUrl/api/randevu/olustur/index.php"; // API URL'si

//   @override
//   void initState() {
//     super.initState();

//     _setBrightness(1.0); // Uygulama başlatıldığında ekran parlaklığını artır
//     _getUserData(); // Kullanıcı verilerini al
//     // QR kodunu her 5 saniyede bir güncelleyen bir zamanlayıcı başlatıyoruz
//     _timer = Timer.periodic(const Duration(seconds: 5), (_) {
//       _sendQrCodeToApi();
//     });
//   }

//   // Kullanıcı verilerini almak için SharedDataService'ı kullanıyoruz
//   Future<void> _getUserData() async {
//     try {
//       user = await SharedDataService().getLoginData();
//     } catch (e) {}
//   }

//   // Ekran parlaklığını ayarlayan fonksiyon
//   Future<void> _setBrightness(double brightness) async {
//     try {
//       _originalBrightness = await ScreenBrightness().current; // Mevcut parlaklık değerini al
//       await ScreenBrightness().setScreenBrightness(brightness); // Yeni parlaklık değeri ayarla
//     } catch (e) {}
//   }

//   // QR kodu ve kullanıcı ID'sini API'ye gönderen fonksiyon
//   Future<void> _sendQrCodeToApi() async {
//     if (user != null && user!.id != null && currentQrCode != null) {
//       try {
//         final response = await http.post(
//           Uri.parse(apiUrl),
//           headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//           body: {
//             'token': token,
//             'id': user!.id.toString(), // Kullanıcı ID'sini gönderiyoruz
//             'qr_code': currentQrCode!, // QR kodunu da göndermeliyiz
//           },
//         );

//         if (response.statusCode == 200) {
//           final Map<String, dynamic> responseData = jsonDecode(response.body);
//           if (responseData['status'] == 'SUCCESS') {
//           } else {}
//         } else {}
//       } catch (e) {}
//     } else {}
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // Zamanlayıcıyı durdur
//     if (_originalBrightness != null) {
//       // Parlaklık değerini eski haline getir
//       ScreenBrightness().setScreenBrightness(_originalBrightness!);
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(30),
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
//               // QR kodu kütüphanesini kullanarak QR kodunu göster
//               currentQrCode != null
//                   ? PrettyQrView.data(
//                       data: currentQrCode!, // QR kodunun içeriği olarak API'den alınan değeri kullanıyoruz
//                       errorCorrectLevel: QrErrorCorrectLevel.H, // Hata düzeltme seviyesi
//                       decoration: const PrettyQrDecoration(), // QR dekorasyonu
//                     )
//                   : const CircularProgressIndicator(), // QR kodu yüklenirken gösterilecek animasyon
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
  late UserModel? user; // Kullanıcı modeli
  Timer? _timer; // QR kodunun otomatik yenilenmesi için zamanlayıcı
  double? _originalBrightness; // Ekran parlaklık değeri
  String? currentQrCode; // Mevcut QR kodu
  final String apiUrl = "https://$apiBaseUrl/api/randevu/olustur/index.php"; // API adresi
  List<String> qrCodes = []; // QR kodlarının listesi

  @override
  void initState() {
    super.initState();
    _setBrightness(1.0); // Uygulama başlatıldığında ekran parlaklığını artır
    _getUserData().then((_) {
      _fetchQrCodes().then((_) {
        // QR kodunu her 5 saniyede bir yenileyen zamanlayıcı
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {});
          if ((timer.tick + 1) % 5 == 0) {
            _updateQrCode(); // QR kodunu güncelle
          }
        });
      }); // API'den QR kodlarını çek
    }); // Kullanıcı verilerini al
  }

  // Kullanıcı verilerini SharedDataService'den al
  Future<void> _getUserData() async {
    try {
      user = await SharedDataService().getLoginData();
    } catch (e) {
      debugPrint("Kullanıcı verisi alınırken hata oluştu: $e");
    }
  }

  // API'den QR kodlarını çek ve parse et
  Future<void> _fetchQrCodes() async {
    if (user == null || user!.id == null) return; // Kullanıcı giriş yapmamışsa durdur

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'id': user!.id.toString(),
          'qrolustur': '1',
          'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
        }, // Kullanıcı ID'sini gönderiyoruz
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        QR qrData = QR.fromJson(responseData); // JSON'u QR modeline dönüştür
        if (qrData.status == 'SUCCESS' && qrData.qrkodlar != null) {
          print("merhab");
          setState(() {
            print(qrData.qrkodlar);
            qrCodes = qrData.qrkodlar!; // QR kodlarını state'e at
          });
        }
      } else {
        debugPrint("API hatası: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("QR kodları alınırken hata oluştu: $e");
    }
  }

  // QR kodunu güncelleme fonksiyonu
  void _updateQrCode() {
    if (qrCodes.isNotEmpty) {
      Random random = Random();
      String selectedQrCode = qrCodes[random.nextInt(qrCodes.length)]; // Rastgele QR kodu seç
      setState(() {
        currentQrCode = selectedQrCode; // QR kodunu güncelle
      });
    }
  }

  // Ekran parlaklığını ayarlayan fonksiyon
  Future<void> _setBrightness(double brightness) async {
    try {
      _originalBrightness = await ScreenBrightness().current; // Mevcut parlaklık
      await ScreenBrightness().setScreenBrightness(brightness); // Yeni parlaklık
    } catch (e) {
      debugPrint("Ekran parlaklığı ayarlanamadı: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Zamanlayıcıyı durdur
    if (_originalBrightness != null) {
      ScreenBrightness().setScreenBrightness(_originalBrightness!); // Parlaklığı eski haline getir
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 30, left: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "QR Kodunuz (Her 5 sn'de bir yenileniyor)",
                style: TextStyle(fontSize: 20, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              currentQrCode != null
                  ? Column(
                      children: [
                        if (_timer != null)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Container(
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: (_timer!.tick + 1) % 5 + 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 4 - (_timer!.tick + 1) % 5, child: const SizedBox.shrink()),
                                ],
                              ),
                            ),
                          ),
                        PrettyQrView.data(
                          data: currentQrCode!, // QR kodu içeriği

                          // elementColor: Colors.black,
                          // roundEdges: true,
                          // size: double.maxFinite,
                          // size: 200,
                        ),
                      ],
                    )
                  : const CircularProgressIndicator(), // QR kodu yüklenirken göster
            ],
          ),
        ),
      ),
    );
  }
}
