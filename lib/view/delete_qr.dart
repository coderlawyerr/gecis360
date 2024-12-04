
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class myyqrr extends StatelessWidget {
  const myyqrr({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // QR kodunun üstünde gösterilecek yazı
              const Text(
                "QR Her 5 sn bir yenileniyor ",
                style: TextStyle(fontSize: 25, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20), // Yazı ile QR kodu arasında boşluk
              PrettyQrView.data(
                data: 'https://pub.dev/packages/pretty_qr_code', // QR kod içeriği
                errorCorrectLevel: QrErrorCorrectLevel.H, // Hata düzeltme seviyesi
                decoration: const PrettyQrDecoration(), // Dekorasyon
              ),
            ],
          ),
        ),
      ),
    );
  }
}