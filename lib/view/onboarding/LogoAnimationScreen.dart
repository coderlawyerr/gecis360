import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/services/markaHelper.dart';
import 'package:armiyaapp/view/home_page.dart';
import 'package:armiyaapp/view/login.dart';
import 'package:flutter/material.dart';

class LogoAnimationScreen extends StatefulWidget {
  @override
  _LogoAnimationScreenState createState() => _LogoAnimationScreenState();
}

class _LogoAnimationScreenState extends State<LogoAnimationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animasyon Kontrolcüsünü Başlat
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // Animasyon süresini 5 saniye olarak ayarladık
      vsync: this,
    );

    // Animasyonlar: Dönme, Opaklık ve Ölçek
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.1416).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Animasyonu Başlat
    _controller.forward();

    // Animasyonun tamamlandığını dinlemek için listener ekleyelim
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animasyon tamamlandı, yönlendirme işlemi yapalım
        Future.delayed(Duration(seconds: 1), () async {
          // Burada yeni sayfaya yönlendirme işlemi yapıyoruz

          var user = await SharedDataService().getLoginData();
          if (user != null) {
            MarkaHelper.setMarka(user.markaadi!);
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => user == null ? LoginPage() : const HomePage()), // Yeni sayfanın adı
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Animasyonların tümünü burada kullanıyoruz
            return Transform.rotate(
              angle: _rotationAnimation.value, // Dönme animasyonu
              child: Opacity(
                opacity: _opacityAnimation.value, // Opaklık animasyonu
                child: Transform.scale(
                  scale: _scaleAnimation.value, // Ölçek animasyonu
                  child: Image.asset(
                    'assets/onboarding.png', // Logonuzun yolu
                    width: 250,
                    height: 250,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
