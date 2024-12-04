// import 'package:armiyaapp/const/const.dart';
// import 'package:armiyaapp/data/app_shared_preference.dart';
// import 'package:armiyaapp/model/usermodel.dart';
// import 'package:armiyaapp/services/auth_service.dart';
// import 'package:armiyaapp/services/markaHelper.dart';

// import 'package:armiyaapp/view/home_page.dart';
// import 'package:armiyaapp/view/select_marka.dart';

// import 'package:armiyaapp/widget/button.dart';
// import 'package:armiyaapp/widget/textfield.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';

// import '../navigator/custom_navigator.dart';

// class LoginPage extends StatefulWidget {
//   LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final AuthService _authService = AuthService();
//   UserModel? myusermodel;

//   @override
//   initState() {
//     SharedDataService().removeUserData();
//     MarkaHelper.removeMarka();
//     super.initState();
//   }

//   Future<void> login(BuildContext context) async {
//     final String email = emailController.text;
//     final String password = passwordController.text;
//     final AppNavigator nav = AppNavigator.instance;
//     try {
//       // AuthService üzerinden login işlemi
//       final response = await _authService.login(email, password);
//       print(response);
//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);

//         if (data is Map<String, dynamic>) {
//           final Map<String, dynamic> responseData = data;
//           UserModel user = UserModel.fromJson(responseData);
//           // Gelen yanıtı User modeline dönüştür

//           // Yanıtın durumunu kontrol et
//           if (user.status == true) {
//             // Giriş başarılı
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('${user.message}')),
//             );
//             SharedDataService().saveLoginData(response.body);

//             print("Ad Soyad: ${user.isimsoyisim}");
//             print("Yetki Grubu: ${user.yetkiGrubu}");
//             print("Özel Yetkiler: ${user.ozelYetkiler}");
//             // Giriş yapan kullanıcı bilgilerini işleyin
//             MarkaHelper.setMarka(user.markaAdi!);
//             nav.push(context: context, routePage: const HomePage());
//             // Giriş başarılı olursa yönlendirme
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('${user.message}')),
//             );
//           }
//         } else if (data is List) {
//           nav.push(
//             context: context,
//             routePage: SelectMarka(
//               markalar: data.map((e) => Marka.fromJson(e)).toList(),
//               email: email,
//               password: password,
//             ),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Giriş başarısız! ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       print('Bir hata oluştu: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Bir hata oluştu: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(30),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   "HOŞGELDİNİZ",
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal, color: primaryColor),
//                 ),
//               ),
//               SizedBox(
//                 height: 40,
//               ),
//               Text(
//                 "Email",
//                 style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
//               ),
//               CustomTextField(
//                 suffixIcon: Icon(Icons.email, color: Colors.grey),
//                 controller: emailController,
//                 hintText: "E-Posta Adresi & Telefon",
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "Şifre",
//                 style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
//               ),
//               CustomTextField(
//                 suffixIcon: Icon(Icons.key_rounded, color: Colors.grey),
//                 controller: passwordController,
//                 hintText: "Şifre",
//                 keyboardType: TextInputType.text,
//                 isPassword: true,
//               ),
//               const SizedBox(height: 45),
//               Center(
//                 child: CustomButton(
//                   text: "GİRİŞ YAP",
//                   onPressed: () {
//                     login(context);
//                   },
//                   icon: null,
//                 ),
//               ),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:armiyaapp/const/const.dart';
import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/model/usermodel.dart';
import 'package:armiyaapp/services/auth_service.dart';
import 'package:armiyaapp/services/markaHelper.dart';

import 'package:armiyaapp/view/home_page.dart';
import 'package:armiyaapp/view/select_marka.dart';

import 'package:armiyaapp/widget/button.dart';
import 'package:armiyaapp/widget/textfield.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../navigator/custom_navigator.dart';

// LoginPage StatefulWidget'ı tanımlıyoruz
class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// LoginPage'in durumunu (state) yöneten sınıf
class _LoginPageState extends State<LoginPage> {
  // Email ve şifre giriş alanları için kontrolörler
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // AuthService sınıfı üzerinden yetkilendirme işlemleri
  final AuthService _authService = AuthService();

  // Kullanıcı bilgilerini tutmak için model
  UserModel? myusermodel;

  @override
  void initState() {
    // Sayfa başlatıldığında kullanıcı ve marka verilerini temizliyoruz
    SharedDataService().removeUserData();
    MarkaHelper.removeMarka();
    super.initState();
  }

  // Giriş yapma işlemi için bir fonksiyon
  Future<void> login(BuildContext context) async {
    final String email = emailController.text; // Kullanıcının girdiği email
    final String password = passwordController.text; // Kullanıcının girdiği şifre
    final AppNavigator nav = AppNavigator.instance; // Navigasyon için AppNavigator örneği
    try {
      // AuthService üzerinden giriş işlemi yapılıyor
      final response = await _authService.login(email, password);
      print(response);

      // Eğer sunucudan başarılı bir yanıt dönerse
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes)); // Yanıt verisini JSON formatında çözümle

        if (data is Map<String, dynamic>) {
          // Eğer dönen veri bir haritaysa (tek marka için)
          final Map<String, dynamic> responseData = data;
          UserModel user = UserModel.fromJson(responseData); // Kullanıcı modeline dönüştür

          // Giriş durumu başarılı mı kontrol ediyoruz
          if (user.status == true) {
            // Başarılı giriş mesajı göster
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${user.message}')),
            );

            // Giriş yapan kullanıcı verilerini cihazda sakla
            SharedDataService().saveLoginData(utf8.decode(response.bodyBytes));

            // Kullanıcı bilgilerini konsola yazdır
            print("Ad Soyad: ${user.isimsoyisim}");
            print("Yetki Grubu: ${user.yetkiGrubu}");
            print("Özel Yetkiler: ${user.ozelYetkiler}");

            // Marka adını sakla
            MarkaHelper.setMarka(user.markaAdi!);

            // Ana sayfaya yönlendir
            nav.pushReplacement(context: context, routePage: const HomePage());
          } else {
            // Başarısız giriş mesajı göster
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${user.message}')),
            );
          }
        } else if (data is List) {
          if (data.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Giriş başarısız! Email veya şifre hatalı')),
            );
          } else {
            // Eğer dönen veri bir listeyse (birden fazla marka seçeneği için)
            nav.push(
              context: context,
              routePage: SelectMarka(
                markalar: data.map((e) => Marka.fromJson(e)).toList(), // Marka listesini dönüştür
                email: email,
                password: password,
              ),
            );
          }
        }
      } else {
        // Sunucu yanıtı başarısızsa mesaj göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Giriş başarısız! ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Hata durumunda mesaj ve hata detayı göster
      print('Bir hata oluştu: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arka plan rengi beyaz
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30), // Kenar boşlukları
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Ortalanmış içerik
            crossAxisAlignment: CrossAxisAlignment.start, // Sol hizalı içerik
            children: [
              Align(
                alignment: Alignment.center, // Hoşgeldiniz yazısını ortala
                child: Text(
                  "HOŞGELDİNİZ",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal, color: primaryColor),
                ),
              ),
              SizedBox(height: 40), // Boşluk
              Text(
                "Email",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
              ),
              // E-posta giriş alanı
              CustomTextField(
                suffixIcon: Icon(Icons.email, color: Colors.grey), // İkon
                controller: emailController, // Kontrolör
                hintText: "E-Posta Adresi & Telefon",
              ),
              SizedBox(height: 25),
              Text(
                "Şifre",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
              ),
              // Şifre giriş alanı
              CustomTextField(
                suffixIcon: Icon(Icons.key_rounded, color: Colors.grey), // İkon
                controller: passwordController, // Kontrolör
                hintText: "Şifre",
                keyboardType: TextInputType.text, // Klavye tipi
                isPassword: true, // Şifre gizliliği
              ),
              const SizedBox(height: 45),
              // Giriş Yap butonu
              Center(
                child: CustomButton(
                  text: "GİRİŞ YAP",
                  onPressed: () {
                    login(context); // Butona tıklandığında login fonksiyonunu çalıştır
                  },
                  icon: null,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
