import 'package:armiyaapp/view/active_appointments.dart';
import 'package:armiyaapp/view/canceled_appointment.dart';
import 'package:armiyaapp/view/past_appointments.dart';
import 'package:flutter/material.dart';

class MyTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        animationDuration: Duration.zero,
        length: 3, // Toplam sekme sayısı
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Column(
            children: [
              TabBar(
                padding: EdgeInsets.only(left: 0), // Sol taraftaki boşluğu sıfırlamak için
                indicatorPadding: EdgeInsets.zero, // İndikatör boşluğunu kaldırır
                labelPadding: EdgeInsets.symmetric(horizontal: 20), // Sekmelerin etrafındaki boşluk
                isScrollable: true, // Kaydırılabilir hale getirir
                tabs: [
                  Tab(
                    icon: Icon(Icons.calendar_today),
                   
                    text: 'Aktif Randevular', // Aktif randevu sekmesi
                  ),
                  Tab(
                    icon: Icon(Icons.block),
                  
                    text: 'Geçmiş Randevular', // Geçmiş randevu sekmesi
                  ),
                  Tab(
                    icon: Icon(Icons.history),
                    
                    text: 'İptal Edilen Randevular', // İptal edilen randevu sekmesi
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ActiveAppointment(), // Aktif randevular sayfası
                    PassAppointment(), // Geçmiş randevular sayfası
                    CanceledAppointment(), // İptal edilen randevular sayfası
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
