// import 'package:armiyaapp/model/kayit_model.dart';
// import 'package:armiyaapp/services/kayit_service.dart';
// import 'package:flutter/material.dart';

// class Yourrecords extends StatefulWidget {
//   const Yourrecords({super.key});

//   @override
//   State<Yourrecords> createState() => _YourrecordsState();
// }

// class _YourrecordsState extends State<Yourrecords> {
//   List<kayit> _data = [];
//   List<bool> isExpanded = [false, false, false];

//   // Servisi çağırarak veri çekme
//   Future<void> _fetchData() async {
//     try {
//       List<kayit> kayitlar = await KayitOlustur().kayitolustur();
//       setState(() {
//         _data = kayitlar;
//       });
//     } catch (e) {
//       // Hata durumunda kullanıcıyı bilgilendirebiliriz
//       print("Veri çekme hatası: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchData(); // Veriyi çekmek için servis çağrısını yapıyoruz
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
//         child: Column(
//           children: [
//             Center(
//               child: const Text(
//                 "KAYITLARINIZ",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: isExpanded.length,
//                 itemBuilder: (context, index) {
//                   return AnimatedContainer(
//                     duration: const Duration(milliseconds: 300), // Animasyon
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.3),
//                           spreadRadius: 2,
//                           blurRadius: 8,
//                           offset: const Offset(0, 4), // Gölgeli görünüm
//                         ),
//                       ],
//                     ),
//                     child: Recordwiget(
//                       isExpanded: isExpanded[index],
//                       onTap: () {
//                         setState(() {
//                           isExpanded[index] = !isExpanded[index];
//                         });
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Recordwiget extends StatelessWidget {
//   final bool isExpanded;
//   final VoidCallback onTap;
//   const Recordwiget({super.key, required this.isExpanded, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text(
//                     "Betül Şensoy",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   Text(
//                     "Ofis",
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   Text(
//                     "Giriş Saati : 12:30",
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   Text(
//                     "Durum : Çıkış Yapmadı",
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: onTap,
//                 child: Icon(
//                   isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                   size: 28,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           // Genişleyen Detaylar
//           if (isExpanded)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Divider(color: Colors.grey, thickness: 0.5),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Detaylar:",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 const Text("• Giriş Saati: 16:30", style: TextStyle(fontSize: 14, color: Colors.black54)),
//                 const Text("• Çıkış Saati: Çıkış Yapamadı", style: TextStyle(fontSize: 14, color: Colors.black54)),
//                 const Text("• Geçirilen Süre: 4:30:20", style: TextStyle(fontSize: 14, color: Colors.black54)),
//                 const Text("• Durum: çıkış yapmadı", style: TextStyle(fontSize: 14, color: Colors.black54)),
//                 const SizedBox(height: 10),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:armiyaapp/model/kayit_model.dart';
// import 'package:armiyaapp/services/kayit_service.dart';
// import 'package:flutter/material.dart';

// class Yourrecords extends StatefulWidget {
//   const Yourrecords({super.key});

//   @override
//   State<Yourrecords> createState() => _YourrecordsState();
// }

// class _YourrecordsState extends State<Yourrecords> {
//   List<kayit> _data = [];

//   Future<void> _fetchData() async {
//     try {
//       // API'den veri çekme kısmı
//       List<kayit> kayitlar = await KayitOlustur().kayitolustur(); // Kendi API servisinizi çağırın.
//       setState(() {
//         _data = kayitlar;
//       });
//     } catch (e) {
//       print("Veri çekme hatası: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Kayıtlarınız"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _data.isEmpty
//             ? const Center(child: CircularProgressIndicator())
//             : ListView.builder(
//                 itemCount: _data.length,
//                 itemBuilder: (context, index) {
//                   return RecordWidget(kayitItem: _data[index]);
//                 },
//               ),
//       ),
//     );
//   }
// }

// class RecordWidget extends StatelessWidget {
//   final kayit kayitItem;

//   const RecordWidget({super.key, required this.kayitItem});

//   // Hexadecimal renk kodunu dönüştürme fonksiyonu
//   Color _getColorFromHex(String? hexColor) {
//     if (hexColor == null || !hexColor.startsWith('0x') || hexColor.length != 10) {
//       return Colors.black; // Varsayılan renk
//     }
//     try {
//       return Color(int.parse(hexColor));
//     } catch (e) {
//       return Colors.black; // Hatalıysa varsayılan renk
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Kullanıcı bilgisi ve tesis bilgisi
//             Text(
//               kayitItem.kullaniciIsimsoyisim ?? "Ad Soyad Bilinmiyor",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               kayitItem.tesisAd ?? "Bilinmiyor",
//               style: const TextStyle(fontSize: 14, color: Colors.black54),
//             ),
//             Text(
//               kayitItem.hizmetAd ?? "Bilinmiyor",
//               style: const TextStyle(fontSize: 14, color: Colors.black54),
//             ),
//             const SizedBox(height: 10),
//             // Giriş ve çıkış tarihleri
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   kayitItem.girisTarihi ?? "Bilinmiyor",
//                   style: const TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//                 Text(
//                   kayitItem.cikisTarihi ?? "Bilinmiyor",
//                   style: const TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             // Geçirilen süre
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   kayitItem.gecirilenSure ?? "Bilinmiyor",
//                   style: const TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//                 // Renkli gösterim
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: _getColorFromHex(kayitItem.gecirilenSureRenk), // Hex rengini kontrol et ve uygula
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: const Text(
//                     "Durum",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:armiyaapp/model/kayit_model.dart';
// import 'package:armiyaapp/services/kayit_service.dart';
// import 'package:flutter/material.dart';

// class Yourrecords extends StatefulWidget {
//   const Yourrecords({super.key});

//   @override
//   State<Yourrecords> createState() => _YourrecordsState();
// }

// class _YourrecordsState extends State<Yourrecords> {
//   List<kayit> _data = [];

//   // Veri çekme işlemi
//   Future<void> _fetchData() async {
//     try {
//       List<kayit> kayitlar = await KayitOlustur().kayitolustur(); // API'den veri al
//       setState(() {
//         _data = kayitlar;
//       });
//     } catch (e) {
//       print("Veri çekme hatası: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchData(); // Veriyi başlatırken alıyoruz
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Kayıtlarınız"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _data.isEmpty
//             ? const Center(child: CircularProgressIndicator()) // Veri yoksa yükleniyor spinnerı
//             : ListView.builder(
//                 itemCount: _data.length, // Liste uzunluğuna göre item oluşturulacak
//                 itemBuilder: (context, index) {
//                   return RecordWidget(kayitItem: _data[index]); // Her bir kayıt için widget
//                 },
//               ),
//       ),
//     );
//   }
// }

// class RecordWidget extends StatelessWidget {
//   final kayit kayitItem;

//   const RecordWidget({super.key, required this.kayitItem});

//   // Hexadecimal renk kodunu dönüştürme fonksiyonu
//   Color _getColorFromHex(String? hexColor) {
//     if (hexColor == null || !hexColor.startsWith('0x') || hexColor.length != 10) {
//       return Colors.black; // Varsayılan renk
//     }
//     try {
//       return Color(int.parse(hexColor));
//     } catch (e) {
//       return Colors.black; // Hatalıysa varsayılan renk
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Kullanıcı bilgisi ve tesis bilgisi
//             Text(
//               kayitItem.kullaniciIsimsoyisim ?? "Ad Soyad Bilinmiyor",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               kayitItem.tesisAd ?? "Bilinmiyor",
//               style: const TextStyle(fontSize: 14, color: Colors.black54),
//             ),
//             Text(
//               kayitItem.hizmetAd ?? "Bilinmiyor",
//               style: const TextStyle(fontSize: 14, color: Colors.black54),
//             ),
//             const SizedBox(height: 10),
//             // Giriş ve çıkış tarihleri
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   kayitItem.girisTarihi ?? "Bilinmiyor",
//                   style: const TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//                 Text(
//                   kayitItem.cikisTarihi ?? "Bilinmiyor",
//                   style: const TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             // Geçirilen süre
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   kayitItem.gecirilenSure ?? "Bilinmiyor",
//                   style: const TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//                 // Durum butonu (renkli gösterim)
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: _getColorFromHex(kayitItem.gecirilenSureRenk), // Hex rengini kontrol et ve uygula
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: const Text(
//                     "Durum",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:armiyaapp/model/kayit_model.dart';
import 'package:armiyaapp/services/kayit_service.dart';
import 'package:flutter/material.dart';

class Yourrecords extends StatefulWidget {
  const Yourrecords({super.key});

  @override
  State<Yourrecords> createState() => _YourrecordsState();
}

class _YourrecordsState extends State<Yourrecords> {
  List<kayit> _data = [];
  List<bool> isExpanded = [];

  // Servisi çağırarak veri çekme
  Future<void> _fetchData() async {
    try {
      List<kayit> kayitlar = await KayitOlustur().kayitolustur();
      setState(() {
        _data = kayitlar;
        isExpanded = List<bool>.filled(kayitlar.length, false); // Her kayda bir genişleme durumu tanımlıyoruz
      });
    } catch (e) {
      // Hata durumunda kullanıcıyı bilgilendirebiliriz
      print("Veri çekme hatası: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Veriyi çekmek için servis çağrısını yapıyoruz
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
          children: [
            const Center(
              child: Text(
                "KAYITLARINIZ",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300), // Animasyon
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4), // Gölgeli görünüm
                        ),
                      ],
                    ),
                    child: Recordwiget(
                      kayitBilgisi: _data[index],
                      isExpanded: isExpanded[index],
                      onTap: () {
                        setState(() {
                          isExpanded[index] = !isExpanded[index];
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Recordwiget extends StatelessWidget {
  final kayit kayitBilgisi;
  final bool isExpanded;
  final VoidCallback onTap;

  const Recordwiget({
    super.key,
    required this.kayitBilgisi,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kayitBilgisi.tesisAd ?? "Bilinmeyen Kullanıcı",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Giriş Saati : ${kayitBilgisi.girisTarihi ?? 'Bilinmiyor'}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    "Durum : ${kayitBilgisi.cikisTarihi == null ? 'Çıkış Yapmadı' : 'Tamamlandı'}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onTap,
                child: Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 28,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Genişleyen Detaylar
          if (isExpanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: Colors.grey, thickness: 0.5),
                const SizedBox(height: 10),
                const Text(
                  "Detaylar:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "• Giriş Saati: ${kayitBilgisi.girisTarihi ?? 'Bilinmiyor'}",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  "• Çıkış Saati: ${kayitBilgisi.cikisTarihi ?? 'Çıkış Yapamadı'}",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  "• Geçirilen Süre: ${kayitBilgisi.gecirilenSure ?? 'Bilinmiyor'}",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 10),
              ],
            ),
        ],
      ),
    );
  }
}
