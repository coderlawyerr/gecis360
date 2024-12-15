// To parse this JSON data, do
//
//     final groupDetailsResponse = groupDetailsResponseFromJson(jsonString);

import 'dart:convert';

GroupDetailsResponse groupDetailsResponseFromJson(String str) =>
    GroupDetailsResponse.fromJson(json.decode(str));

String groupDetailsResponseToJson(GroupDetailsResponse data) =>
    json.encode(data.toJson());

class GroupDetailsResponse {
  List<Bilgi>? bilgi;
  List<Secilisaatler>? secilisaatler;
  List<dynamic>? randevu;
  List<Uyegruplari>? uyegruplari;
  List<int>? kayitolacaklar;

  GroupDetailsResponse({
    this.bilgi,
    this.secilisaatler,
    this.randevu,
    this.uyegruplari,
    this.kayitolacaklar,
  });

  factory GroupDetailsResponse.fromJson(Map<String, dynamic> json) =>
      GroupDetailsResponse(
        bilgi: List<Bilgi>.from(json["bilgi"].map((x) => Bilgi.fromJson(x))),
        secilisaatler: List<Secilisaatler>.from(
            json["secilisaatler"].map((x) => Secilisaatler.fromJson(x))),
        randevu: List<dynamic>.from(json["randevu"].map((x) => x)),
        uyegruplari: List<Uyegruplari>.from(
            json["uyegruplari"].map((x) => Uyegruplari.fromJson(x))),
        kayitolacaklar: List<int>.from(json["kayitolacaklar"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "bilgi": List<dynamic>.from(bilgi!.map((x) => x.toJson())),
        "secilisaatler":
            List<dynamic>.from(secilisaatler!.map((x) => x.toJson())),
        "randevu": List<dynamic>.from(randevu!.map((x) => x)),
        "uyegruplari": List<dynamic>.from(uyegruplari!.map((x) => x.toJson())),
        "kayitolacaklar": List<dynamic>.from(kayitolacaklar!.map((x) => x)),
      };
}

class Bilgi {
  int? hizmetId;
  String? hizmetAd;
  String? hizmetTuru;
  int? saatlikKapasite;
  String? randevuZamanlayici;
  int? ozelalan;
  int? limitsizkapasite;
  int? misafirKabul;
  int? grupRandevusu;
  int? randevusuzGiris;
  int? gunlukGirissayisi;
  String? kullanimSuresi;
  int? cikisKontrolu;
  int? aktif;

  Bilgi({
    this.hizmetId,
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
    this.cikisKontrolu,
    this.aktif,
  });

  factory Bilgi.fromJson(Map<String, dynamic> json) => Bilgi(
        hizmetId: json["hizmet_id"],
        hizmetAd: json["hizmet_ad"],
        hizmetTuru: json["hizmet_turu"],
        saatlikKapasite: json["saatlik_kapasite"],
        randevuZamanlayici: json["randevu_zamanlayici"],
        ozelalan: json["ozelalan"],
        limitsizkapasite: json["limitsizkapasite"],
        misafirKabul: json["misafir_kabul"],
        grupRandevusu: json["grup_randevusu"],
        randevusuzGiris: json["randevusuz_giris"],
        gunlukGirissayisi: json["gunluk_girissayisi"],
        kullanimSuresi: json["kullanim_suresi"],
        cikisKontrolu: json["cikis_kontrolu"],
        aktif: json["aktif"],
      );

  Map<String, dynamic> toJson() => {
        "hizmet_id": hizmetId,
        "hizmet_ad": hizmetAd,
        "hizmet_turu": hizmetTuru,
        "saatlik_kapasite": saatlikKapasite,
        "randevu_zamanlayici": randevuZamanlayici,
        "ozelalan": ozelalan,
        "limitsizkapasite": limitsizkapasite,
        "misafir_kabul": misafirKabul,
        "grup_randevusu": grupRandevusu,
        "randevusuz_giris": randevusuzGiris,
        "gunluk_girissayisi": gunlukGirissayisi,
        "kullanim_suresi": kullanimSuresi,
        "cikis_kontrolu": cikisKontrolu,
        "aktif": aktif,
      };
}

class Secilisaatler {
  int? hizmetId;
  String? hizmetad;
  String? gun;
  String? baslangicsaati;
  String? bitissaati;
  String? periyot;

  Secilisaatler({
    this.hizmetId,
    this.hizmetad,
    this.gun,
    this.baslangicsaati,
    this.bitissaati,
    this.periyot,
  });

  factory Secilisaatler.fromJson(Map<String, dynamic> json) => Secilisaatler(
        hizmetId: json["hizmet_id"],
        hizmetad: json["hizmetad"],
        gun: json["gun"],
        baslangicsaati: json["baslangicsaati"],
        bitissaati: json["bitissaati"],
        periyot: json["periyot"],
      );

  Map<String, dynamic> toJson() => {
        "hizmet_id": hizmetId,
        "hizmetad": hizmetad,
        "gun": gun,
        "baslangicsaati": baslangicsaati,
        "bitissaati": bitissaati,
        "periyot": periyot,
      };
}

class Uyegruplari {
  int? grupId;
  dynamic ekleyenId;
  String? grupAdi;
  String? grupYetkili;
  String? uyeler;
  int? aktif;
  List<int>? uyegrubulistesi;
  List<int>? kayitolacaklar;

  Uyegruplari({
    this.grupId,
    this.ekleyenId,
    this.grupAdi,
    this.grupYetkili,
    this.uyeler,
    this.aktif,
    this.uyegrubulistesi,
    this.kayitolacaklar,
  });

  factory Uyegruplari.fromJson(Map<String, dynamic> json) => Uyegruplari(
        grupId: json["grup_id"],
        ekleyenId: json["ekleyen_id"],
        grupAdi: json["grup_adi"],
        grupYetkili: json["grup_yetkili"],
        uyeler: json["uyeler"],
        aktif: json["aktif"],
        uyegrubulistesi: List<int>.from(json["uyegrubulistesi"].map((x) => x)),
        kayitolacaklar: List<int>.from(json["kayitolacaklar"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "grup_id": grupId,
        "ekleyen_id": ekleyenId,
        "grup_adi": grupAdi,
        "grup_yetkili": grupYetkili,
        "uyeler": uyeler,
        "aktif": aktif,
        "uyegrubulistesi": List<dynamic>.from(uyegrubulistesi!.map((x) => x)),
        "kayitolacaklar": List<dynamic>.from(kayitolacaklar!.map((x) => x)),
      };
}
