import 'dart:convert';

import 'package:armiyaapp/const/const.dart';
import 'package:armiyaapp/model/usermodel.dart';
import 'package:armiyaapp/navigator/custom_navigator.dart';
import 'package:armiyaapp/services/forgot_service.dart';
import 'package:armiyaapp/view/login.dart';

import 'package:armiyaapp/view/select_marka_two.dart';

import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  ForgotService _forgotService = ForgotService();
  Future<void> handleForgotPasswordResponse() async {
    final response = await _forgotService.forgotPassword(emailController.text.trim());

    if (response.statusCode == 200) {
      final responseBody = response.body;

      try {
        // Yanıtın JSON olduğunu kontrol et
        List<dynamic> jsonData = jsonDecode(responseBody); // Liste olarak çözümle

        // Markaları liste halinde alıyoruz
        List<Marka> markalar = jsonData.map((markaJson) => Marka.fromJson(markaJson)).toList();

        // Markaları ekrana yazdırmak
        markalar.forEach((marka) {
          print('Marka Adı: ${marka.adi}, db_user: ${marka.dbUser}, db_name: ${marka.dbName}');
        });

        // Başarı mesajı
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Markalar başarıyla alındı')),
        );
      } catch (e) {
        print('Hata: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yanıt işlenirken bir hata oluştu')),
        );
      }
    } else {
      print('API Hatası: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('API Hatası: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 45, right: 20, left: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Dialogu kapat
                    },
                    color: primaryColor,
                    icon: Icon(Icons.arrow_back_ios_new_sharp),
                  ),
                  SizedBox(
                    width: 45,
                  ),
                  Text(
                    "Şifremi Unuttum",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Image(
                image: AssetImage("assets/lock.png"),
                height: 180,
                width: 200,
              ),
              SizedBox(height: 20),
              const Center(
                child: Text(
                  "Aşağıdaki formdan e-posta adresinize bir şifre sıfırlama bağlantısı gönderebilirsiniz.",
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'E posta adresini yaz',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 25),
              MaterialButton(
                onPressed: () async {
                  if (emailController.text.trim().isNotEmpty) {
                    try {
                      final response = await _forgotService.forgotPassword(emailController.text.trim());

                      print('Gelen Yanıt: ${response.body}'); // Yanıtın tamamını konsola yazdırıyoruz

                      if (response.statusCode == 200) {
                        bool isValid = response.body.contains("OK");
                        if (isValid) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Şifreninz sıfırlamaya devam etmek için kayıtlı mail adresinizi kontrol edin.')),
                          );
                          AppNavigator.instance.pushReplacement(
                            context: context,
                            routePage: LoginPage(),
                          );
                          return;
                        }
                        // Yanıtın JSON olduğunu kontrol et
                        final responseBody = utf8.decode(response.bodyBytes);
                        print('Dönüşen Yanıt: $responseBody'); // Yanıtı kontrol et

                        // JSON'u çözümle
                        List<dynamic> responseData = jsonDecode(responseBody); // Burada liste olarak çözümle

                        // Gelen JSON'un bir liste olduğunu kontrol et
                        if (responseData is List) {
                          final markalar = responseData.map((marka) => Marka.fromJson(marka)).toList();

                          if (markalar.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectMarkaTwo(
                                  markalar: markalar,
                                  kullaniciadi: emailController.text.trim(),
                                ),
                              ),
                            );
                          } else {
                            // Gelen JSON boş bir listeyse
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Kullanıcıya ait marka bulunamadı.')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Beklenmeyen veri formatı alındı.')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Şifre sıfırlama başarısız! ${response.statusCode}')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bir hata oluştu: $e')),
                      );
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: primaryColor,
                child: const Text(
                  'Şifremi Yenile',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> forgot(BuildContext context, String? db_name) async {
    final AppNavigator nav = AppNavigator.instance;
    try {
      final response = await _forgotService.forgotPassword(emailController.text, db_name);
      print(response.body);
      bool isValid = response.body.contains("OK");
      if (response.statusCode == 200 && isValid) {
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Giriş başarısız! ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }
}
