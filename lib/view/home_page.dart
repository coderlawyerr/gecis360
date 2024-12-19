import 'dart:ui';
import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/model/usermodel.dart';
import 'package:armiyaapp/services/markaHelper.dart';

import 'package:armiyaapp/view/settings_page.dart';

import 'package:armiyaapp/view/login.dart';
import 'package:armiyaapp/view/your_records.dart';
import 'package:armiyaapp/widget/table.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:armiyaapp/const/const.dart';

import 'pretty_qr.dart';

final GlobalKey<HomePageState> homePageKey = GlobalKey<HomePageState>();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  UserModel? userModel;
  String? selectedMarkaName;
  final SharedDataService _sharedDataService = SharedDataService();
  int page = 0;
  void sayfaGuncelle(int index) {
    print("sayfaGuncelle Çalıştı");
    setState(() {
      page = index;
    });
  }

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getUserData();
    getSelectedMarka();
  }

  // Seçilen markayı almak için fonksiyon
  Future<void> getSelectedMarka() async {
    String? markaName = await MarkaHelper.getMarka(); // Markayı al
    setState(() {
      selectedMarkaName = markaName;
    });
  }

  // Kullanıcı adını ayarlamak için bir fonksiyon
  getUserData() async {
    print("getUserData");
    _sharedDataService.getLoginData().then((userData) {
      userModel = userData;
      setState(() {});
    });
  }

  // Her sekme için ilgili sayfa widget'ını döndüren fonksiyon
  Widget getSelectedPage(int index) {
    getSelectedMarka();
    switch (index) {
      case 0:
        return Yourrecords(); // Randevular
      case 1:
        return PrettyQrHomePage();
      case 2:
        return SettingPage(); // QR Kod
      default:
        return PrettyQrHomePage(); // Varsayılan sayfa
    }
  }

  // Çıkış uyarısı için bulanık arka planlı alert dialog
  void showExitDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // Kullanıcının dialog dışında tıklayarak kapatmasına izin verir
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Arka plan bulanıklığı
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Çıkış Yapmak Üzeresin !'),
            content: const Text('Çıkmak istediğinizden emin misiniz?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Dialogu kapat
                },
                child: const Text('Hayır', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Dialogu kapat
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Evet', style: TextStyle(color: primaryColor)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight), // AppBar boyutunu ayarlıyoruz
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellow, Colors.orange], // Gradyan renkleri
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent, // AppBar'ın kendi arka planını şeffaf yapıyoruz
            elevation: 0, // AppBar'ın gölgesini kaldırıyoruz
            title: Text(
              (selectedMarkaName ?? "Firma Seçilmedi").toUpperCase(), // Markayı büyük harflerle göster
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: page,
        items: const <Widget>[
          Icon(Icons.book, size: 30, color: Colors.white), // Randevular
          Icon(Icons.qr_code, size: 30, color: Colors.white), // Randevu Oluştur
          Icon(Icons.tune, size: 30, color: Colors.white), // QR Kod
          // Icon(Icons.book, size: 30, color: Colors.white), // kayıt
          // Icon(Icons.tune, size: 30, color: Colors.white), //çıkış
        ],
        color: primaryColor,
        buttonBackgroundColor: primaryColor,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (index) {
          sayfaGuncelle(index);
          // Eğer çıkış sayfası (index == 3) seçildiyse dialog göster
          // if (index == 3) {
          //   showExitDialog();
          // }
        },
        letIndexChange: (index) => true,
      ),
      body: getSelectedPage(page), // Alt menüden seçilen sayfayı burada gösteriyoruz
    );
  }
}
