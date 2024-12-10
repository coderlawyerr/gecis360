import 'dart:convert';
import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/model/usermodel.dart';
import 'package:armiyaapp/navigator/custom_navigator.dart';
import 'package:armiyaapp/services/auth_service.dart';
import 'package:armiyaapp/services/markaHelper.dart';
import 'package:armiyaapp/view/home_page.dart';
import 'package:flutter/material.dart';

class SelectMarka extends StatefulWidget {
  const SelectMarka({
    super.key,
    required this.markalar,
    required this.email,
    required this.password,
  });

  final List<Marka> markalar;
  final String email;
  final String password;

  @override
  State<SelectMarka> createState() => _SelectMarkaState();
}

class _SelectMarkaState extends State<SelectMarka> {
  final AppNavigator nav = AppNavigator.instance;
  final SharedDataService _sharedDataService = SharedDataService();
  final AuthService _authService = AuthService();
  bool isLoading = false;
  String? seciliMarka;
  List<Marka> get markalar => widget.markalar;

  tekMarkaKontrolu() async {
    if (markalar.length == 1) {
      var marka = markalar.first;
      MarkaHelper.setMarka(marka.db_user);
      login(context, marka.db_user);
    }
  }

  Future<void> login(BuildContext context, String? markaDbUser) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _authService.login(widget.email, widget.password, markaDbUser);
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        UserModel user = UserModel.fromJson(data);
        if (user.status == true) {
          SharedDataService().saveLoginData(utf8.decode(response.bodyBytes));
          MarkaHelper.setMarka(user.markaadi!);
          nav.pushReplacement(
            context: context,
            routePage: HomePage(),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${user.message}')),
          );
        }
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
                            login(context, marka.db_user);
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
