import 'dart:convert'; // JSON parsing için gerekli
import 'package:armiyaapp/const/const.dart';
import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/model/usermodel.dart';
import 'package:armiyaapp/services/auth_service.dart';
import 'package:armiyaapp/utils/constants.dart';
import 'package:armiyaapp/view/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTP istekleri için gerekli
import 'package:armiyaapp/data/app_shared_preference.dart';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final TextEditingController namesurname = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController mail = TextEditingController();
  final TextEditingController oldpassword = TextEditingController();
  final TextEditingController newpassword = TextEditingController();
  final TextEditingController repaetnewpassword = TextEditingController();
  UserModel? userModel;

  @override
  void initState() {
    super.initState();

    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedDataService sharedDataService = SharedDataService();
    final data = await sharedDataService.getLoginData();

    if (data != null) {
      setState(() {
        userModel = data;
        namesurname.text = data.isimsoyisim ?? ''; // İsim ve soyisim
        phone.text = data.telefon ?? ''; // Telefon
        mail.text = data.eposta ?? ''; // E-posta
      });
    } else {
      print("Kullanıcı verisi alınamadı.");
    }
  }

  Future<void> updatePassword() async {
    final user = await SharedDataService().getLoginData();
    String apiUrl = 'https://$apiBaseUrl/api/genel/index.php';

    // Gerekli validasyonlar
    if (oldpassword.text.trim().isEmpty || newpassword.text.trim().isEmpty || repaetnewpassword.text.trim().isEmpty) {
      _showErrorDialog('Lütfen tüm alanları doldurun.');
      return;
    }

    // Yeni şifreler eşleşiyor mu kontrolü
    if (newpassword.text.trim() != repaetnewpassword.text.trim()) {
      _showErrorDialog('Yeni şifreler eşleşmiyor.');
      return;
    }

    try {
      // API isteği
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
          'bilgileriKaydet': '1',
          'mevcutSifre': oldpassword.text.trim(),
          'yeniSifre': newpassword.text.trim(),
          'yeniSifreTekrar': repaetnewpassword.text.trim(),
          'id': user?.iD?.toString() ?? "",
        },
      );

      print('HTTP Durum Kodu: ${response.statusCode}');
      print('Gelen yanıt: ${response.body}'); // Yanıtı yazdırın

      // Yanıtın durumunu kontrol et
      if (response.statusCode == 200) {
        final responseBody = response.body.trim();

        if (responseBody == 'SUCCESS') {
          _showSuccessDialog('Şifre başarıyla güncellendi.');
        } else if (responseBody == 'ESLESMEHATA') {
          _showErrorDialog('Yeni şifreler eşleşmiyor.');
        } else if (responseBody == 'MEVCUTHATA') {
          _showErrorDialog('Mevcut şifre yanlış.');
        } else {
          _showErrorDialog('Bilinmeyen bir hata oluştu.');
        }
      } else {
        _showErrorDialog('API isteği başarısız oldu: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Hata (Exception): $e');
      _showErrorDialog('Hata (Exception): $e');
    }
  }

// Başarı mesajı için alert
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Başarı'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        );
      },
    );
  }

// Hata mesajı için alert
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hata Oldu'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 216, 216, 216),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 216, 216, 216),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 40,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                      // İsim Soyisim
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: namesurname,
                          enabled: false, // Değiştirilemez
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 6), // Yatayda padding ekler
                            hintText: "İsim Soyisim",
                            suffixIcon: Icon(Icons.person, color: primaryColor),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      // Telefon
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: phone,
                          enabled: false, // Değiştirilemez
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 6), // Yatayda padding ekler
                            hintText: "Telefon",
                            suffixIcon: Icon(Icons.phone, color: primaryColor),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      // Eposta
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: mail,
                          enabled: false, // Değiştirilemez
                          decoration: InputDecoration(
                            hintText: "Eposta",
                            suffixIcon: Icon(Icons.mail, color: primaryColor),
                            contentPadding: EdgeInsets.symmetric(horizontal: 6), // Yatayda padding ekler
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ),

                      ///mevcut sıfreyı yaz
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: oldpassword,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 6), // Yatayda padding ekler
                            hintText: "Mevcut Şifreni Yaz",
                            suffixIcon: Icon(Icons.password, color: primaryColor),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      // Yeni Şifre
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: newpassword,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 6), // Yatayda padding ekler
                            hintText: "Yeni Şifre",
                            suffixIcon: Icon(Icons.password, color: primaryColor),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      // Şifre Tekrar
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: repaetnewpassword,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 6), // Yatayda padding ekler
                            hintText: "Şifre Tekrar Yaz",
                            suffixIcon: Icon(Icons.password, color: primaryColor),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      // Kaydet Butonu
                      TextButton(
                        onPressed: () {
                          updatePassword();
                          // Şifre kaydetme işlemi yapılabilir
                        },
                        child: Text(
                          "Kaydet",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}





















































// import 'dart:convert'; // JSON parsing için gerekli
// import 'package:armiyaapp/const/const.dart';
// import 'package:armiyaapp/data/app_shared_preference.dart';
// import 'package:armiyaapp/model/usermodel.dart';
// import 'package:armiyaapp/services/auth_service.dart';
// import 'package:armiyaapp/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http; // HTTP istekleri için gerekli
// import 'package:armiyaapp/data/app_shared_preference.dart';

// class EditProfilPage extends StatefulWidget {
//   const EditProfilPage({super.key});

//   @override
//   State<EditProfilPage> createState() => _EditProfilPageState();
// }

// class _EditProfilPageState extends State<EditProfilPage> {
//   final TextEditingController namesurname = TextEditingController();
//   final TextEditingController phone = TextEditingController();
//   final TextEditingController mail = TextEditingController();
//   final TextEditingController oldpassword = TextEditingController();
//   final TextEditingController newpassword = TextEditingController();
//   final TextEditingController repaetnewpassword = TextEditingController();
//   UserModel? userModel;

//   @override
//   void initState() {
//     super.initState();

//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     SharedDataService sharedDataService = SharedDataService();
//     final data = await sharedDataService.getLoginData();

//     if (data != null) {
//       setState(() {
//         userModel = data;
//         namesurname.text = data.isimsoyisim ?? ''; // İsim ve soyisim
//         phone.text = data.telefon ?? ''; // Telefon
//         mail.text = data.eposta ?? ''; // E-posta
//       });
//     } else {
//       print("Kullanıcı verisi alınamadı.");
//     }
//   }

//   Future<void> updatePassword() async {
//     final user = await SharedDataService().getLoginData();
//     String apiUrl = 'https://$apiBaseUrl/api/genel/index.php';

//     // Gerekli validasyonlar
//     if (oldpassword.text.trim().isEmpty || newpassword.text.trim().isEmpty || repaetnewpassword.text.trim().isEmpty) {
//       _showErrorDialog('Lütfen tüm alanları doldurun.');
//       return;
//     }

//     // Yeni şifreler eşleşiyor mu kontrolü
//     if (newpassword.text.trim() != repaetnewpassword.text.trim()) {
//       _showErrorDialog('Yeni şifreler eşleşmiyor.');
//       return;
//     }

//     try {
//       // API isteği
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//         body: {
//           'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
//           'bilgileriKaydet': '1',
//           'mevcutSifre': oldpassword.text.trim(),
//           'yeniSifre': newpassword.text.trim(),
//           'yeniSifreTekrar': repaetnewpassword.text.trim(),
//           'id': user?.iD?.toString() ?? "",
//         },
//       );

//       print('HTTP Durum Kodu: ${response.statusCode}');
//       print('Gelen yanıt: ${response.body}'); // Yanıtı yazdırın

//       // Yanıtın durumunu kontrol et
//       if (response.statusCode == 200) {
//         final responseBody = response.body.trim();

//         if (responseBody == 'SUCCESS') {
//           _showSuccessDialog('Şifre başarıyla güncellendi.');
//         } else if (responseBody == 'ESLESMEHATA') {
//           _showErrorDialog('Yeni şifreler eşleşmiyor.');
//         } else if (responseBody == 'MEVCUTHATA') {
//           _showErrorDialog('Mevcut şifre yanlış.');
//         } else {
//           _showErrorDialog('Bilinmeyen bir hata oluştu.');
//         }
//       } else {
//         _showErrorDialog('API isteği başarısız oldu: HTTP ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Hata (Exception): $e');
//       _showErrorDialog('Hata (Exception): $e');
//     }
//   }

// // Başarı mesajı için alert
//   void _showSuccessDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Başarı'),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Tamam'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

// // Hata mesajı için alert
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Hata Oldu'),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Tamam'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color.fromARGB(255, 216, 216, 216),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       backgroundColor: const Color.fromARGB(255, 216, 216, 216),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
//           child: Column(
//             children: [
//               Card(
//                 color: Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       const CircleAvatar(
//                         backgroundColor: Colors.grey,
//                         radius: 40,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       const Divider(
//                         color: Colors.grey,
//                         thickness: 2,
//                       ),
//                       // İsim Soyisim
//                       Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: TextField(
//                           controller: namesurname,
//                           enabled: false, // Değiştirilemez
//                           decoration: InputDecoration(
//                             hintText: "İsim Soyisim",
//                             suffixIcon: const Icon(Icons.person, color: Colors.grey),
//                             contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(3),
//                             ),
//                           ),
//                         ),
//                       ),
//                       // Telefon
//                       Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: TextField(
//                           controller: phone,
//                           enabled: false, // Değiştirilemez
//                           decoration: InputDecoration(
//                             hintText: "Telefon",
//                             suffixIcon: const Icon(Icons.phone, color: Colors.grey),
//                             contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(3),
//                             ),
//                           ),
//                         ),
//                       ),
//                       // Eposta
//                       Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: TextField(
//                           controller: mail,
//                           enabled: false, // Değiştirilemez
//                           decoration: InputDecoration(
//                             hintText: "Eposta",
//                             suffixIcon: const Icon(Icons.mail, color: Colors.grey),
//                             contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(3),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       const Divider(
//                         color: Colors.grey,
//                         thickness: 2,
//                       ),

//                       ///mevcut sıfreyı yaz
//                       Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: TextField(
//                           controller: oldpassword,
//                           decoration: InputDecoration(
//                             hintText: "Mevcut Şifreni Yaz",
//                             suffixIcon: const Icon(Icons.password, color: Colors.grey),
//                             contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(3),
//                             ),
//                           ),
//                         ),
//                       ),
//                       // Yeni Şifre
//                       Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: TextField(
//                           controller: newpassword,
//                           decoration: InputDecoration(
//                             hintText: "Yeni Şifre",
//                             suffixIcon: const Icon(Icons.password, color: Colors.grey),
//                             contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(3),
//                             ),
//                           ),
//                         ),
//                       ),
//                       // Şifre Tekrar
//                       Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: TextField(
//                           controller: repaetnewpassword,
//                           decoration: InputDecoration(
//                             hintText: "Şifre Tekrar Yaz",
//                             suffixIcon: const Icon(Icons.password, color: Colors.grey),
//                             contentPadding: const EdgeInsets.symmetric(vertical: 5),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(3),
//                             ),
//                           ),
//                         ),
//                       ),
//                       // Kaydet Butonu
//                       TextButton(
//                         onPressed: () {
//                           updatePassword();
//                           // Şifre kaydetme işlemi yapılabilir
//                         },
//                         child: Text(
//                           "Kaydet",
//                           style: TextStyle(color: primaryColor),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
















