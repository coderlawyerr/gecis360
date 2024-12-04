// // models/hizmetler.dart
// import 'dart:convert';

// import 'package:flutter/material.dart';

// import 'randevu_zamanlayici.dart';

// class Hizmetler {
//   final int? hizmetId;
//   final String? hizmetAd;
//   final String? hizmetTuru;
//   final int? saatlikKapasite;
//   final String? randevuZamanlayici; // JSON string olarak geliyor
//   final int? ozelAlan;
//   final int? limitsizKapasite;
//   final int? misafirKabul;
//   final int? grupRandevusu;
//   final int? randevusuzGiris;
//   final int? gunlukGirissayisi;
//   final int? kullanimSuresi;
//   final int? aktif;

//   List<RandevuZamanlayici> zamanlayiciList;

//   Hizmetler({
//     this.hizmetId,
//     this.hizmetAd,
//     this.hizmetTuru,
//     this.saatlikKapasite,
//     this.randevuZamanlayici,
//     this.ozelAlan,
//     this.limitsizKapasite,
//     this.misafirKabul,
//     this.grupRandevusu,
//     this.randevusuzGiris,
//     this.gunlukGirissayisi,
//     this.kullanimSuresi,
//     this.aktif,
//     this.zamanlayiciList = const [],
//   });

//   factory Hizmetler.fromJson(Map<String, dynamic> json) {
//     List<RandevuZamanlayici> zamanlayiciList = [];
//     if (json['randevu_zamanlayici'] != null && json['randevu_zamanlayici'] is String) {
//       try {
//         List<dynamic> list = jsonDecode(json['randevu_zamanlayici']);
//         zamanlayiciList = list.map((item) => RandevuZamanlayici.fromJson(item)).toList();
//       } catch (e) {
//         debugPrint('Randevu zamanlayici çözümleme hatası: $e');
//       }
//     }

//     return Hizmetler(
//       hizmetId: json['hizmet_id'] as int?,
//       hizmetAd: json['hizmet_ad'] as String?,
//       hizmetTuru: json['hizmet_turu'] as String?,
//       saatlikKapasite: json['saatlik_kapasite'] as int?,
//       randevuZamanlayici: json['randevu_zamanlayici'] as String?,
//       ozelAlan: json['ozelalan'] as int?,
//       limitsizKapasite: json['limitsizkapasite'] as int?,
//       misafirKabul: json['misafir_kabul'] as int?,
//       grupRandevusu: json['grup_randevusu'] as int?,
//       randevusuzGiris: json['randevusuz_giris'] as int?,
//       gunlukGirissayisi: json['gunluk_girissayisi'] as int?,
//       kullanimSuresi: json['kullanim_suresi'] as int?,
//       aktif: json['aktif'] as int?,
//       zamanlayiciList: zamanlayiciList,
//     );
//   }
// }
