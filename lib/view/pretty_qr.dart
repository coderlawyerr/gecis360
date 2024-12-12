import 'dart:async'; // Zamanlayıcı işlemleri için
import 'dart:convert'; // JSON işlemleri için
import 'dart:math'; // Rastgele seçim işlemleri için
import 'package:armiyaapp/data/app_shared_preference.dart'; // Kullanıcı verilerini yönetmek için
import 'package:armiyaapp/model/qr_model.dart'; // QR modelini kullanmak için
import 'package:armiyaapp/model/usermodel.dart'; // Kullanıcı modelini kullanmak için
import 'package:armiyaapp/utils/constants.dart'; // Uygulama sabitlerini kullanmak için
import 'package:flutter/material.dart'; // Flutter widget'ları için
import 'package:http/http.dart' as http; // HTTP istekleri yapmak için
import 'package:pretty_qr_code/pretty_qr_code.dart'; // QR kodlarını oluşturmak için
import 'package:screen_brightness/screen_brightness.dart'; // Ekran parlaklığını yönetmek için

class PrettyQrHomePage extends StatefulWidget {
  const PrettyQrHomePage({Key? key}) : super(key: key); // Yapıcı fonksiyon

  @override
  State<PrettyQrHomePage> createState() => _PrettyQrHomePageState(); // State sınıfını döndür
}

class _PrettyQrHomePageState extends State<PrettyQrHomePage> {
  late UserModel? user; // Kullanıcı modelini tanımlıyoruz
  Timer? _timer; // QR kodunun otomatik yenilenmesi için zamanlayıcı
  String? currentQrCode; // Mevcut QR kodu
  final String apiUrl = "https://$apiBaseUrl/api/randevu/olustur/index.php"; // API adresi
  List<String> qrCodes = []; // QR kodlarının listesi
  int _counter = 5; // Sayaç değeri (5'ten başlayacak)

  @override
  void initState() {
    super.initState(); // Parent initState fonksiyonunu çağırıyoruz

    _getUserData().then((_) {
      // Kullanıcı verilerini alıyoruz
      _fetchQrCodes().then((_) {
        // QR kodlarını API'den alıyoruz
        _updateQrCode(); // İlk QR kodunu hemen ayarlıyoruz

        // QR kodunu her saniyede bir yenileyen zamanlayıcı başlatıyoruz
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _counter--; // Sayaç değeri bir azaltılır
          });

          if (_counter <= 0) {
            setState(() {
              _counter = 5; // Sayaç sıfırlandığında tekrar 5'e set edilir
              _updateQrCode(); // QR kodu yenilenir
            });
          }
        });
      });
    });
  }

  // Kullanıcı verilerini SharedDataService'den al
  Future<void> _getUserData() async {
    try {
      user = await SharedDataService().getLoginData(); // Kullanıcı verilerini çek
    } catch (e) {
      debugPrint("Kullanıcı verisi alınırken hata oluştu: $e"); // Hata durumunda yazdır
    }
  }

  // API'den QR kodlarını çek ve parse et
  Future<void> _fetchQrCodes() async {
    if (user == null || user!.iD == null) return; // Kullanıcı giriş yapmamışsa durdur

    try {
      final response = await http.post(
        // HTTP POST isteği gönder
        Uri.parse(apiUrl), // API URL'si
        headers: {'Content-Type': 'application/x-www-form-urlencoded'}, // Başlık bilgisi
        body: {
          'id': user!.iD.toString(), // Kullanıcı ID'sini gönder
          'qrolustur': '1', // QR oluşturma parametresi
          'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as', // API güvenlik tokeni
        },
      );

      if (response.statusCode == 200) {
        // Başarılı yanıt kontrolü
        final Map<String, dynamic> responseData = jsonDecode(response.body); // JSON'u çözümle
        QR qrData = QR.fromJson(responseData); // JSON'u modele dönüştür
        if (qrData.status == 'SUCCESS' && qrData.qrkodlar != null) {
          // Başarı kontrolü
          setState(() {
            qrCodes = qrData.qrkodlar!; // QR kodlarını state'e at
          });
        }
      } else {
        debugPrint("API hatası: ${response.statusCode}"); // API hata durumu
      }
    } catch (e) {
      debugPrint("QR kodları alınırken hata oluştu: $e"); // Hata durumunda yazdır
    }
  }

  // QR kodunu güncelleme fonksiyonu
  void _updateQrCode() {
    if (qrCodes.isNotEmpty) {
      // QR kod listesi boş değilse
      Random random = Random(); // Rastgele seçim için Random nesnesi oluştur
      String selectedQrCode = qrCodes[random.nextInt(qrCodes.length)]; // Rastgele QR kodu seç
      setState(() {
        currentQrCode = selectedQrCode; // QR kodunu güncelle
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Timer'ı durdur
    super.dispose(); // Parent dispose fonksiyonunu çağır
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20, right: 50, left: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 10),
                child: Text(
                  '(Randevu saatiniz dışında giriş yapamazsınız.)', // Artan sayaç
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.grey),
                ),
              ),
              if (currentQrCode != null)
                PrettyQr(
                  data: currentQrCode!,
                  size: 250.0,
                  typeNumber: 3,
                  errorCorrectLevel: QrErrorCorrectLevel.M,
                ),
              const SizedBox(height: 20),
              Text(
                'Qr kod her 5 saniyede\n bir yenilenmektedir: $_counter', // Artan sayaç
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.grey),
              ),
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
