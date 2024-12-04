import 'dart:convert';

import 'package:armiyaapp/model/new_model/newmodel.dart';

class Hizmetbilgisi {
  int? hizmetId;
  String? hizmetAd;
  String? hizmetTuru;
  int? saatlikKapasite;
  RandevuZamanlayici? randevuZamanlayici;
  int? ozelalan;
  int? limitsizkapasite;
  int? misafirKabul;
  int? grupRandevusu;
  int? randevusuzGiris;
  int? gunlukGirissayisi;
  int? kullanimSuresi;
  int? aktifsaatler;
  String? aktifsaatBaslangic;
  String? aktifsaatBitis;
  int? cikisKontrolu;
  int? aktif;

  Hizmetbilgisi(
      {this.hizmetId,
      this.hizmetAd,
      this.hizmetTuru,
      this.saatlikKapasite,
      this.randevuZamanlayici,
      this.ozelalan,
      this.limitsizkapasite,
      this.misafirKabul,
      this.grupRandevusu,
      this.randevusuzGiris,
      this.gunlukGirissayisi,
      this.kullanimSuresi,
      this.aktifsaatler,
      this.aktifsaatBaslangic,
      this.aktifsaatBitis,
      this.cikisKontrolu,
      this.aktif});

  Hizmetbilgisi.fromJson(Map<String, dynamic> json) {
    List randevuZamanlayici1 = jsonDecode(json['randevu_zamanlayici']);
    Map<String, dynamic> randevuJson = randevuZamanlayici1.first ?? {};
    hizmetId = json['hizmet_id'];
    hizmetAd = json['hizmet_ad'];
    hizmetTuru = json['hizmet_turu'];
    saatlikKapasite = json['saatlik_kapasite'];
    randevuZamanlayici = RandevuZamanlayici.fromMap(randevuZamanlayici1.first);
    ozelalan = json['ozelalan'];
    limitsizkapasite = json['limitsizkapasite'];
    misafirKabul = json['misafir_kabul'];
    grupRandevusu = json['grup_randevusu'];
    randevusuzGiris = json['randevusuz_giris'];
    gunlukGirissayisi = json['gunluk_girissayisi'];
    kullanimSuresi = int.tryParse(json['kullanim_suresi'].toString());
    aktifsaatler = json['aktifsaatler'];
    aktifsaatBaslangic = json['aktifsaat_baslangic'];
    aktifsaatBitis = json['aktifsaat_bitis'];
    cikisKontrolu = json['cikis_kontrolu'];
    aktif = json['aktif'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hizmet_id'] = this.hizmetId;
    data['hizmet_ad'] = this.hizmetAd;
    data['hizmet_turu'] = this.hizmetTuru;
    data['saatlik_kapasite'] = this.saatlikKapasite;
    data['randevu_zamanlayici'] = this.randevuZamanlayici;
    data['ozelalan'] = this.ozelalan;
    data['limitsizkapasite'] = this.limitsizkapasite;
    data['misafir_kabul'] = this.misafirKabul;
    data['grup_randevusu'] = this.grupRandevusu;
    data['randevusuz_giris'] = this.randevusuzGiris;
    data['gunluk_girissayisi'] = this.gunlukGirissayisi;
    data['kullanim_suresi'] = this.kullanimSuresi;
    data['aktifsaatler'] = this.aktifsaatler;
    data['aktifsaat_baslangic'] = this.aktifsaatBaslangic;
    data['aktifsaat_bitis'] = this.aktifsaatBitis;
    data['cikis_kontrolu'] = this.cikisKontrolu;
    data['aktif'] = this.aktif;
    return data;
  }
}
