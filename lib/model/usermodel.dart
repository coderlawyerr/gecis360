import 'dart:convert';

import 'package:flutter/material.dart';

class UserModel {
  bool? status;
  String? message;
  int? iD;
  String? markaadi;
  String? isimsoyisim;
  String? telefon;
  String? eposta;
  String? sifre;
  String? profilResmi;
  String? yetkiGrubu;
  String? ozelYetkiler;

  UserModel(
      {this.status,
      this.message,
      this.iD,
      this.markaadi,
      this.isimsoyisim,
      this.telefon,
      this.eposta,
      this.sifre,
      this.profilResmi,
      this.yetkiGrubu,
      this.ozelYetkiler});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    iD = json['ID'];
    markaadi = json['markaadi'];
    isimsoyisim = json['isimsoyisim'];
    telefon = json['telefon'];
    eposta = json['eposta'];
    sifre = json['sifre'];
    profilResmi = json['profil_resmi'];
    yetkiGrubu = json['yetki_Grubu'];
    ozelYetkiler = json['ozelYetkiler'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['ID'] = this.iD;
    data['markaadi'] = this.markaadi;
    data['isimsoyisim'] = this.isimsoyisim;
    data['telefon'] = this.telefon;
    data['eposta'] = this.eposta;
    data['sifre'] = this.sifre;
    data['profil_resmi'] = this.profilResmi;
    data['yetki_Grubu'] = this.yetkiGrubu;
    data['ozelYetkiler'] = this.ozelYetkiler;
    return data;
  }
}

// class Marka {
//   late String db_user;
//   late String db_name;
//   late String adi;

//   Marka.fromJson(Map<String, dynamic> json) {
//     db_user = json['db_user'];
//     db_name = json['db_name'];
//     adi = json['marka_adi'];
//   }
// }

class Marka {
  final String dbUser; // db_user özelliği
  final String dbName; // db_name özelliği
  final String adi;    // marka_adi özelliği

  Marka({required this.dbUser, required this.dbName, required this.adi});

  factory Marka.fromJson(Map<String, dynamic> json) {
    return Marka(
      dbUser: json['db_user'] ?? '',
      dbName: json['db_name'] ?? '',
      adi: json['marka_adi'] ?? '',
    );
  }
}

