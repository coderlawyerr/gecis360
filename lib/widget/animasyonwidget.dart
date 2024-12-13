import 'package:flutter/material.dart';

class ZiplamaAnimationWidget extends StatefulWidget {
  final String imagePath; // Resmin yolunu dışarıdan alacağız

  ZiplamaAnimationWidget({required this.imagePath});

  @override
  _ZiplamaAnimationWidgetState createState() => _ZiplamaAnimationWidgetState();
}

class _ZiplamaAnimationWidgetState extends State<ZiplamaAnimationWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Animasyon kontrolcüsünü başlatıyoruz
    _controller = AnimationController(
      vsync: this, // Bu, animasyonun duraklatılabilir olmasını sağlar
      duration: Duration(seconds: 1), // Animasyon süresi
    )..repeat(reverse: true); // Animasyonu tekrarlatıyoruz, ters yönde de çalışması için 'reverse' kullanıyoruz

    // Zıplama hareketini tanımlıyoruz
    _animation = Tween<double>(begin: 0, end: -50).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Yumuşak bir zıplama hareketi için
    ));
  }

  @override
  void dispose() {
    _controller.dispose(); // Animasyon kontrolcüsünü yok et
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value), // Resmi yukarı aşağı hareket ettiriyoruz
          child: child,
        );
      },
      child: Image.asset(widget.imagePath), // Dışarıdan alınan resmin yolu
    );
  }
}
