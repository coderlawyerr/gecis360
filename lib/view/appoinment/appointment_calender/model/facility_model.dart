import 'dart:convert';

import 'package:flutter/material.dart';

class FacilitySelectModel {
  final int? tesisId;
  final String? tesisAd;
  final String? tesisTel;
  final String? tesisEposta;
  final String? tesisAdres;
  final String? yetkiliAdiSoyadi;
  final String? yetkiliTel;
  final String? yetkiliEposta;
  final int? aktifGunsayisi;
  final List<String>? hizmetler; // String yerine List<String> kullanıyoruz
  final bool? aktif;

  FacilitySelectModel({
    this.tesisId,
    this.tesisAd,
    this.tesisTel,
    this.tesisEposta,
    this.tesisAdres,
    this.yetkiliAdiSoyadi,
    this.yetkiliTel,
    this.yetkiliEposta,
    this.aktifGunsayisi,
    this.hizmetler,
    this.aktif,
  });

  factory FacilitySelectModel.fromJson(Map<String, dynamic> json) {
    // Hizmetler alanı string geliyor, önce kontrol edip sonra çözümlüyoruz
    List<String>? hizmetlerList = [];
    if (json['hizmetler'] != null && json['hizmetler'] is String) {
      try {
        hizmetlerList = List<String>.from(jsonDecode(json['hizmetler']));
      } catch (e) {
        debugPrint('Hizmetler listesi çözümleme hatası: $e');
      }
    }

    return FacilitySelectModel(
      tesisId: json['tesis_id'] as int?,
      tesisAd: json['tesis_ad'] as String?,
      tesisTel: json['tesis_tel'] as String?,
      tesisEposta: json['tesis_eposta'] as String?,
      tesisAdres: json['tesis_adres'] as String?,
      yetkiliAdiSoyadi: json['yetkili_adisoyadi'] as String?,
      yetkiliTel: json['yetkili_tel'] as String?,
      yetkiliEposta: json['yetkili_eposta'] as String?,
      aktifGunsayisi: json['aktif_gunsayisi'] as int?,
      hizmetler: hizmetlerList, // Dönüştürülmüş listeyi atıyoruz
      aktif: json['aktif'] == 1 ? true : false,
    );
  }
}
