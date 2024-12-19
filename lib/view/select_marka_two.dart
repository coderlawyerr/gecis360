import 'dart:convert';
import 'dart:developer';

import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/model/usermodel.dart';
import 'package:armiyaapp/navigator/custom_navigator.dart';
import 'package:armiyaapp/services/auth_service.dart';
import 'package:armiyaapp/services/forgot_service.dart';
import 'package:armiyaapp/services/markaHelper.dart';
import 'package:armiyaapp/view/forgotpassword.dart';
import 'package:armiyaapp/view/home_page.dart';
import 'package:armiyaapp/view/login.dart';
import 'package:flutter/material.dart';

class SelectMarkaTwo extends StatefulWidget {
  const SelectMarkaTwo({
    super.key,
    required this.kullaniciadi,
    required this.markalar,
  });

  final List<Marka> markalar;
  final String kullaniciadi;

  @override
  State<SelectMarkaTwo> createState() => _SelectMarkaState();
}

class _SelectMarkaState extends State<SelectMarkaTwo> {
  final AppNavigator nav = AppNavigator.instance;
  final SharedDataService _sharedDataService = SharedDataService();
  final ForgotService _forgotPassword = ForgotService();
  bool isLoading = false;
  String? seciliMarka;
  List<Marka> get markalar => widget.markalar;

  tekMarkaKontrolu() async {
    if (markalar.length == 1) {
      var marka = markalar.first;
      MarkaHelper.setMarka(marka.dbUser);
      print("ben calısmak sıtıyom");
      forgot(context, marka.dbUser);
    }
  }

  Future<void> forgot(BuildContext context, String? dbName) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _forgotPassword.forgotPassword(widget.kullaniciadi, dbName);
      log(response.body);
      bool isValid = response.body.contains("OK");
      if (response.statusCode == 200 && isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Şifrenizi sıfırlamaya devam etmek için kayıtlı mail adresinizi kontrol edin.')),
        );
        nav.pushReplacement(
          context: context,
          routePage: LoginPage(),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Giriş başarısız! ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    tekMarkaKontrolu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          markalar.isEmpty
              ? const Center(
                  child: Text(
                  "Kullanıcının kayıtlı olduğu bir marka bulunamadı516",
                  style: TextStyle(fontSize: 18),
                ))
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Marka Seç",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ...markalar.map((marka) {
                        return GestureDetector(
                          onTap: () {
                            // MarkaHelper.setMarka(marka.db_user);
                            forgot(context, marka.dbName);
                          },
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [Colors.yellow, Colors.orange],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  marka.adi,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
