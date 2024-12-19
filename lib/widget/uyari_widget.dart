import 'package:armiyaapp/const/const.dart';
import 'package:armiyaapp/view/home_page.dart';
import 'package:flutter/material.dart';

//aktif randevu için
class AktifAppointmnetCard extends StatefulWidget {
  @override
  State<AktifAppointmnetCard> createState() => _AktifAppointmnetCardState();
}

class _AktifAppointmnetCardState extends State<AktifAppointmnetCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Çalıştı");

        homePageKey.currentState?.sayfaGuncelle(1);
      },
      child: Card(
        margin: EdgeInsets.all(
          10,
        ),
        color: primaryColor,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(
                width: 10,
              ),
              Center(
                child: Text(
                  'Aktif Randevunuz Bulunmamaktadır.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
//geçmiş randevu için
//aktif randevu için
class GecmisRandevuCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      color: primaryColor,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Geçmiş randevunuz yok',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////
class IptalEdilenRandevuCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      color: primaryColor,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'İptal edilmiş randevunuz yok',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
