import 'package:armiyaapp/const/const.dart';
import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/model/usermodel.dart';
import 'package:armiyaapp/services/auth_service.dart';
import 'package:armiyaapp/services/markaHelper.dart';
import 'package:armiyaapp/view/forgotpassword.dart';

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

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;
  bool _isPasswordObscure = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  UserModel? myusermodel;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isChecked = await SharedDataService.bildirimOnayGetir();
      if (isChecked) {
        emailController.text = await SharedDataService.mailgetir();
        passwordController.text = await SharedDataService.passwordgetir();
        setState(() {});
      }
    });
    SharedDataService().removeUserData();
    MarkaHelper.removeMarka();
    super.initState();
  }

  Future<void> login(BuildContext context) async {
    final String email = emailController.text;
    final String password = passwordController.text;
    await SharedDataService.loginbilgikaydet(email, password);
    final AppNavigator nav = AppNavigator.instance;
    try {
      final response = await _authService.login(email, password);
      print(response);
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data is Map<String, dynamic>) {
          final Map<String, dynamic> responseData = data;
          UserModel user = UserModel.fromJson(responseData);
          if (user.status == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${user.message}')),
            );
            if (isChecked) {
              SharedDataService().saveLoginData(utf8.decode(response.bodyBytes));
            }
            MarkaHelper.setMarka(user.markaadi!);
            nav.pushReplacement(context: context, routePage: const HomePage());
          } else {
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
            nav.push(
              context: context,
              routePage: SelectMarka(
                markalar: data.map((e) => Marka.fromJson(e)).toList(),
                email: email,
                password: password,
              ),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Giriş başarısız! ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Bir hata oluştu: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "HOŞ GELDİNİZ",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal, color: primaryColor),
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Email",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
              ),
              CustomTextField(
                obscureText: _isPasswordObscure,
                keyboardType: TextInputType.text, // Klavye tipi
                isPassword: false, // Şifre gizliliği
                suffixIcon: Icon(Icons.email, color: Colors.grey),
                controller: emailController,
                hintText: "E-Posta Adresi & Telefon",
              ),
              SizedBox(height: 25),
              Text(
                "Şifre",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
              ),
              CustomTextField(
                isPassword: true, // Bu parametre şifre alanı olduğunu belirtir
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscure = !_isPasswordObscure;
                    });
                  },
                ),
                controller: passwordController,
                hintText: "Şifre",
                obscureText: _isPasswordObscure, // Şifreyi gizleme durumu
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                      },
                      child: Text(
                        "Şifremi Unuttum",
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                    SizedBox(width: 76),
                    Text(
                      "Beni Hatırla",
                      style: TextStyle(color: primaryColor),
                    ),
                    Checkbox(
                      value: isChecked,
                      activeColor: primaryColor,
                      checkColor: Colors.white,
                      side: BorderSide(color: Colors.grey, width: 2.0),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            SharedDataService.bildirimOnayGuncelle(value);
                          }
                          isChecked = value ?? false;
                          if (isChecked) {
                            SharedDataService().saveLoginData(jsonEncode({
                              'email': emailController.text,
                              'password': passwordController.text,
                            }));
                          } else {
                            SharedDataService().removeUserData();
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: CustomButton(
                  text: "GİRİŞ YAP",
                  onPressed: () {
                    login(context);
                  },
                  icon: null,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}






















































































// import 'package:armiyaapp/const/const.dart';
// import 'package:armiyaapp/data/app_shared_preference.dart';
// import 'package:armiyaapp/model/usermodel.dart';
// import 'package:armiyaapp/services/auth_service.dart';
// import 'package:armiyaapp/services/markaHelper.dart';
// import 'package:armiyaapp/view/forgotpassword.dart';

// import 'package:armiyaapp/view/home_page.dart';
// import 'package:armiyaapp/view/select_marka.dart';

// import 'package:armiyaapp/widget/button.dart';
// import 'package:armiyaapp/widget/textfield.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';

// import '../navigator/custom_navigator.dart';

// // LoginPage StatefulWidget'ı tanımlıyoruz
// class LoginPage extends StatefulWidget {
//   LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// // LoginPage'in durumunu (state) yöneten sınıf
// class _LoginPageState extends State<LoginPage> {
//   bool isChecked = false;
//   // Email ve şifre giriş alanları için kontrolörler
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   // AuthService sınıfı üzerinden yetkilendirme işlemleri
//   final AuthService _authService = AuthService();

//   // Kullanıcı bilgilerini tutmak için model
//   UserModel? myusermodel;

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       isChecked = await SharedDataService.bildirimOnayGetir();
//       if (isChecked) {
//         emailController.text = await SharedDataService.mailgetir();
//         passwordController.text = await SharedDataService.passwordgetir();
//         setState(() {});
//       }
//     });
//     // Sayfa başlatıldığında kullanıcı ve marka verilerini temizliyoruz
//     SharedDataService().removeUserData();
//     MarkaHelper.removeMarka();
//     super.initState();
//   }

//   // Giriş yapma işlemi için bir fonksiyon
//   Future<void> login(BuildContext context) async {
//     final String email = emailController.text; // Kullanıcının girdiği email
//     final String password = passwordController.text; // Kullanıcının girdiği şifre
//     await SharedDataService.loginbilgikaydet(email, password);
//     final AppNavigator nav = AppNavigator.instance; // Navigasyon için AppNavigator örneği
//     try {
//       // AuthService üzerinden giriş işlemi yapılıyor
//       final response = await _authService.login(email, password);
//       print(response);

//       // Eğer sunucudan başarılı bir yanıt dönerse
//       if (response.statusCode == 200) {
//         var data = jsonDecode(utf8.decode(response.bodyBytes)); // Yanıt verisini JSON formatında çözümle

//         if (data is Map<String, dynamic>) {
//           // Eğer dönen veri bir haritaysa (tek marka için)
//           final Map<String, dynamic> responseData = data;
//           UserModel user = UserModel.fromJson(responseData); // Kullanıcı modeline dönüştür

//           // Giriş durumu başarılı mı kontrol ediyoruz
//           if (user.status == true) {
//             // Başarılı giriş mesajı göster
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('${user.message}')),
//             );
//             // benı hatırla  işaretliye  kullanıcıyı kaydedıyoruzz

//             if (isChecked) {
//               SharedDataService().saveLoginData(utf8.decode(response.bodyBytes));
//             }
//             // // Giriş yapan kullanıcı verilerini cihazda sakla
//             // SharedDataService().saveLoginData(utf8.decode(response.bodyBytes));

//             // Kullanıcı bilgilerini konsola yazdır
//             print("Ad Soyad: ${user.isimsoyisim}");
//             print("Yetki Grubu: ${user.yetkiGrubu}");
//             print("Özel Yetkiler: ${user.ozelYetkiler}");

//             // Marka adını sakla
//             MarkaHelper.setMarka(user.markaadi!);

//             // Ana sayfaya yönlendir
//             nav.pushReplacement(context: context, routePage: const HomePage());
//           } else {
//             // Başarısız giriş mesajı göster
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('${user.message}')),
//             );
//           }
//         } else if (data is List) {
//           if (data.isEmpty) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Giriş başarısız! Email veya şifre hatalı')),
//             );
//           } else {
//             // Eğer dönen veri bir listeyse (birden fazla marka seçeneği için)
//             nav.push(
//               context: context,
//               routePage: SelectMarka(
//                 markalar: data.map((e) => Marka.fromJson(e)).toList(), // Marka listesini dönüştür
//                 email: email,
//                 password: password,
//               ),
//             );
//           }
//         }
//       } else {
//         // Sunucu yanıtı başarısızsa mesaj göster
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Giriş başarısız! ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       // Hata durumunda mesaj ve hata detayı göster
//       print('Bir hata oluştu: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Bir hata oluştu: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // Arka plan rengi beyaz
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(30), // Kenar boşlukları
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center, // Ortalanmış içerik
//             crossAxisAlignment: CrossAxisAlignment.start, // Sol hizalı içerik
//             children: [
//               Align(
//                 alignment: Alignment.center, // Hoşgeldiniz yazısını ortala
//                 child: Text(
//                   "HOŞ GELDİNİZ",
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal, color: primaryColor),
//                 ),
//               ),
//               SizedBox(height: 40), // Boşluk
//               Text(
//                 "Email",
//                 style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
//               ),
//               // E-posta giriş alanı
//               CustomTextField(
//                 suffixIcon: Icon(Icons.email, color: Colors.grey), // İkon
//                 controller: emailController, // Kontrolör
//                 hintText: "E-Posta Adresi & Telefon",
//               ),
//               SizedBox(height: 25),
//               Text(
//                 "Şifre",
//                 style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
//               ),
//               // Şifre giriş alanı
//               CustomTextField(
                
//                 suffixIcon: Icon(Icons.key_rounded, color: Colors.grey), // İkon
//                 controller: passwordController, // Kontrolör
//                 hintText: "Şifre",
//                 keyboardType: TextInputType.text, // Klavye tipi
//                 isPassword: true, // Şifre gizliliği
//               ),
//               const SizedBox(height: 10),

//               ///beni hatıla
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end, // Öğeleri sağ tarafa hizala
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
//                       },
//                       child: Text(
//                         "Şifremi Unuttum",
//                         style: TextStyle(color: primaryColor),
//                       ),
//                     ),
//                     SizedBox(width: 76), // Şifremi Unuttum ile Beni Hatırla arasına boşluk
//                     Text(
//                       "Beni Hatırla",
//                       style: TextStyle(color: primaryColor),
//                     ),
//                     // SizedBox(width: 5), // Beni Hatırla ile Checkbox arasına az boşluk
//                     Checkbox(
//                       value: isChecked,
//                       activeColor: primaryColor,
//                       checkColor: Colors.white,
//                       side: BorderSide(
//                         color: Colors.grey,
//                         width: 2.0,
//                       ),
//                       onChanged: (bool? value) {
//                         setState(() {
//                           if (value != null) {
//                             SharedDataService.bildirimOnayGuncelle(value);
//                           }

//                           isChecked = value ?? false;
//                           if (isChecked) {
//                             // Checkbox işaretlendiğinde e-posta ve şifreyi kaydedin
//                             SharedDataService().saveLoginData(jsonEncode({
//                               'email': emailController.text,
//                               'password': passwordController.text,
//                             }));
//                           } else {
//                             // Checkbox işareti kaldırıldığında bilgileri silin
//                             SharedDataService().removeUserData();
//                           }
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 50,
//               ),
//               // Giriş Yap butonu
//               Center(
//                 child: CustomButton(
//                   text: "GİRİŞ YAP",
//                   onPressed: () {
//                     login(context); // Butona tıklandığında login fonksiyonunu çalıştır
//                   },
//                   icon: null,
//                 ),
//               ),
//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
