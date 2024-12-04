import 'dart:convert';

class CalendarInfoModel {
  final List<Bilgi>? bilgi;
  final List<Secilisaatler>? secilisaatler;
  final List<Randevu>? randevu;
  final List<Uyegruplari>? uyegruplari;
  final List<int>? kayitolacaklar;
  final List<Hizmetler>? hizmetler;

  CalendarInfoModel({
    this.bilgi,
    this.secilisaatler,
    this.randevu,
    this.uyegruplari,
    this.kayitolacaklar,
    this.hizmetler,
  });

  // fromJson yöntemi artık Map<String, dynamic> alacak şekilde güncellendi
  factory CalendarInfoModel.fromJson(Map<String, dynamic> json) =>
      CalendarInfoModel.fromMap(json);

  String toJson() => json.encode(toMap());

  factory CalendarInfoModel.fromMap(Map<String, dynamic> json) =>
      CalendarInfoModel(
        bilgi: json["bilgi"] == null
            ? []
            : List<Bilgi>.from(json["bilgi"]!.map((x) => Bilgi.fromMap(x))),
        hizmetler: json["hizmetler"] == null
            ? []
            : List<Hizmetler>.from(
                json["hizmetler"]!.map((x) => Hizmetler.fromMap(x))),
        secilisaatler: json["secilisaatler"] == null
            ? []
            : List<Secilisaatler>.from(
                json["secilisaatler"]!.map((x) => Secilisaatler.fromMap(x))),
        randevu: json["randevu"] == null
            ? []
            : List<Randevu>.from(
                json["randevu"]!.map((x) => Randevu.fromMap(x))),
        uyegruplari: json["uyegruplari"] == null
            ? []
            : List<Uyegruplari>.from(
                json["uyegruplari"]!.map((x) => Uyegruplari.fromMap(x))),
        kayitolacaklar: json["kayitolacaklar"] == null
            ? []
            : List<int>.from(json["kayitolacaklar"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "bilgi": bilgi == null
            ? []
            : List<dynamic>.from(bilgi!.map((x) => x.toMap())),
        "secilisaatler": secilisaatler == null
            ? []
            : List<dynamic>.from(secilisaatler!.map((x) => x.toMap())),
        "randevu": randevu == null
            ? []
            : List<dynamic>.from(randevu!.map((x) => x.toMap())),
        "uyegruplari": uyegruplari == null
            ? []
            : List<dynamic>.from(uyegruplari!.map((x) => x.toMap())),
        "kayitolacaklar": kayitolacaklar == null
            ? []
            : List<dynamic>.from(kayitolacaklar!.map((x) => x)),
      };

  @override
  String toString() {
    return 'CalendarInfoModel(bilgi: $bilgi, secilisaatler: $secilisaatler, randevu: $randevu, uyegruplari: $uyegruplari, kayitolacaklar: $kayitolacaklar)';
  }
}

class Bilgi {
  final int? hizmetId;
  final String? hizmetAd;
  final String? hizmetTuru;
  final int? saatlikKapasite;
  final String? randevuZamanlayici;
  final int? ozelalan;
  final int? limitsizkapasite;
  final int? misafirKabul;
  final int? grupRandevusu;
  final int? randevusuzGiris;
  final int? gunlukGirissayisi;
  final int? kullanimSuresi;
  final int? aktif;

  // Zamanlayıcı listesi eklendi
  final List<RandevuZamanlayici>? zamanlayiciList;

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
    this.aktif,
    this.zamanlayiciList,
  });

  // fromJson yöntemi artık Map<String, dynamic> alacak şekilde güncellendi
  factory Bilgi.fromMap(Map<String, dynamic> json) {
    List<RandevuZamanlayici> zamanlayiciList = [];
    if (json["randevu_zamanlayici"] != null &&
        json["randevu_zamanlayici"].isNotEmpty) {
      try {
        // randevu_zamanlayici'nın geçerli bir JSON stringi olduğundan emin olun
        List<dynamic> zamanlayiciJson = jsonDecode(json["randevu_zamanlayici"]);
        zamanlayiciList =
            zamanlayiciJson.map((x) => RandevuZamanlayici.fromMap(x)).toList();
      } catch (e) {
        print('Zamanlayıcı parse hatası: $e');
        // Burada zamanlayıcıyı boş bırakabilirsiniz veya varsayılan bir değer atayabilirsiniz
        zamanlayiciList = [];
      }
    } else {
      print('Zamanlayıcı boş veya null');
    }

    return Bilgi(
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
      aktif: json["aktif"],
      zamanlayiciList: zamanlayiciList,
    );
  }

  Map<String, dynamic> toMap() => {
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
        "aktif": aktif,
      };

  @override
  String toString() {
    return 'Bilgi(hizmetId: $hizmetId, hizmetAd: $hizmetAd, hizmetTuru: $hizmetTuru, saatlikKapasite: $saatlikKapasite, randevuZamanlayici: $randevuZamanlayici, ozelalan: $ozelalan, limitsizkapasite: $limitsizkapasite, misafirKabul: $misafirKabul, grupRandevusu: $grupRandevusu, randevusuzGiris: $randevusuzGiris, gunlukGirissayisi: $gunlukGirissayisi, kullanimSuresi: $kullanimSuresi, aktif: $aktif, zamanlayiciList: $zamanlayiciList)';
  }
}

class Hizmetler {
  final int? hizmetId;
  final String? hizmetAd;
  final String? hizmetTuru;
  final int? saatlikKapasite;
  final String? randevuZamanlayici;
  final int? ozelalan;
  final int? limitsizkapasite;
  final int? misafirKabul;
  final int? grupRandevusu;
  final int? randevusuzGiris;
  final int? gunlukGirissayisi;
  final int? kullanimSuresi;
  final int? aktif;

  // Zamanlayıcı listesi eklendi
  final List<RandevuZamanlayici>? zamanlayiciList;

  Hizmetler({
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
    this.aktif,
    this.zamanlayiciList,
  });

  // fromJson yöntemi artık Map<String, dynamic> alacak şekilde güncellendi
  factory Hizmetler.fromMap(Map<String, dynamic> json) {
    List<RandevuZamanlayici> zamanlayiciList = [];
    if (json["randevu_zamanlayici"] != null &&
        json["randevu_zamanlayici"].isNotEmpty) {
      try {
        // randevu_zamanlayici'nın geçerli bir JSON stringi olduğundan emin olun
        List<dynamic> zamanlayiciJson = jsonDecode(json["randevu_zamanlayici"]);
        zamanlayiciList =
            zamanlayiciJson.map((x) => RandevuZamanlayici.fromMap(x)).toList();
      } catch (e) {
        print('Zamanlayıcı parse hatası: $e');
        // Burada zamanlayıcıyı boş bırakabilirsiniz veya varsayılan bir değer atayabilirsiniz
        zamanlayiciList = [];
      }
    } else {
      print('Zamanlayıcı boş veya null');
    }

    return Hizmetler(
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
      aktif: json["aktif"],
      zamanlayiciList: zamanlayiciList,
    );
  }

  Map<String, dynamic> toMap() => {
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
        "aktif": aktif,
      };

  @override
  String toString() {
    return 'Bilgi(hizmetId: $hizmetId, hizmetAd: $hizmetAd, hizmetTuru: $hizmetTuru, saatlikKapasite: $saatlikKapasite, randevuZamanlayici: $randevuZamanlayici, ozelalan: $ozelalan, limitsizkapasite: $limitsizkapasite, misafirKabul: $misafirKabul, grupRandevusu: $grupRandevusu, randevusuzGiris: $randevusuzGiris, gunlukGirissayisi: $gunlukGirissayisi, kullanimSuresi: $kullanimSuresi, aktif: $aktif, zamanlayiciList: $zamanlayiciList)';
  }
}

class Randevu {
  final DateTime? baslangictarihi;
  final DateTime? bitistarihi;
  final String? formatlibaslangictarihi;
  final String? formatlibitistarihi;
  final String? baslangicsaati;
  final String? bitissaati;
  final int? kullaniciid;
  final int? hizmetid;
  final String? hizmetad;
  final int? kapasite;

  Randevu({
    this.baslangictarihi,
    this.bitistarihi,
    this.formatlibaslangictarihi,
    this.formatlibitistarihi,
    this.baslangicsaati,
    this.bitissaati,
    this.kullaniciid,
    this.hizmetid,
    this.hizmetad,
    this.kapasite,
  });

  factory Randevu.fromJson(Map<String, dynamic> json) => Randevu.fromMap(json);

  get saat => null;

  String toJson() => json.encode(toMap());

  factory Randevu.fromMap(Map<String, dynamic> json) => Randevu(
        baslangictarihi: json["baslangictarihi"] == null
            ? null
            : DateTime.parse(json["baslangictarihi"]),
        bitistarihi: json["bitistarihi"] == null
            ? null
            : DateTime.parse(json["bitistarihi"]),
        formatlibaslangictarihi: json["formatlibaslangictarihi"],
        formatlibitistarihi: json["formatlibitistarihi"],
        baslangicsaati: json["baslangicsaati"],
        bitissaati: json["bitissaati"],
        kullaniciid: json["kullaniciid"],
        hizmetid: json["hizmetid"],
        hizmetad: json["hizmetad"],
        kapasite: json["kapasite"],
      );

  Map<String, dynamic> toMap() => {
        "baslangictarihi": baslangictarihi?.toIso8601String(),
        "bitistarihi": bitistarihi?.toIso8601String(),
        "formatlibaslangictarihi": formatlibaslangictarihi,
        "formatlibitistarihi": formatlibitistarihi,
        "baslangicsaati": baslangicsaati,
        "bitissaati": bitissaati,
        "kullaniciid": kullaniciid,
        "hizmetid": hizmetid,
        "hizmetad": hizmetad,
        "kapasite": kapasite,
      };
  @override
  String toString() {
    return 'Randevu(baslangictarihi: $baslangictarihi, bitistarihi: $bitistarihi, formatlibaslangictarihi: $formatlibaslangictarihi, formatlibitistarihi: $formatlibitistarihi, baslangicsaati: $baslangicsaati, bitissaati: $bitissaati, kullaniciid: $kullaniciid, hizmetid: $hizmetid, hizmetad: $hizmetad, kapasite: $kapasite)';
  }
}

class Secilisaatler {
  final int? hizmetId;
  final String? hizmetad;
  final String? gun;
  final String? baslangicsaati;
  final String? bitissaati;
  final String? periyot;

  Secilisaatler({
    this.hizmetId,
    this.hizmetad,
    this.gun,
    this.baslangicsaati,
    this.bitissaati,
    this.periyot,
  });

  factory Secilisaatler.fromJson(Map<String, dynamic> json) =>
      Secilisaatler.fromMap(json);

  String toJson() => json.encode(toMap());

  factory Secilisaatler.fromMap(Map<String, dynamic> json) => Secilisaatler(
        hizmetId: json["hizmet_id"],
        hizmetad: json["hizmetad"],
        gun: json["gun"],
        baslangicsaati: json["baslangicsaati"],
        bitissaati: json["bitissaati"],
        periyot: json["periyot"],
      );

  Map<String, dynamic> toMap() => {
        "hizmet_id": hizmetId,
        "hizmetad": hizmetad,
        "gun": gun,
        "baslangicsaati": baslangicsaati,
        "bitissaati": bitissaati,
        "periyot": periyot,
      };
}

class Uyegruplari {
  final int? grupId;
  final String? grupAdi;
  final String? grupYetkili;
  final String? uyeler;
  final int? aktif;
  final List<int>? uyegrubulistesi;
  final List<int>? kayitolacaklar;

  Uyegruplari({
    this.grupId,
    this.grupAdi,
    this.grupYetkili,
    this.uyeler,
    this.aktif,
    this.uyegrubulistesi,
    this.kayitolacaklar,
  });

  factory Uyegruplari.fromJson(Map<String, dynamic> json) =>
      Uyegruplari.fromMap(json);

  String toJson() => json.encode(toMap());

  factory Uyegruplari.fromMap(Map<String, dynamic> json) => Uyegruplari(
        grupId: json["grup_id"],
        grupAdi: json["grup_adi"],
        grupYetkili: json["grup_yetkili"],
        uyeler: json["uyeler"],
        aktif: json["aktif"],
        uyegrubulistesi: json["uyegrubulistesi"] == null
            ? []
            : List<int>.from(json["uyegrubulistesi"]!.map((x) => x)),
        kayitolacaklar: json["kayitolacaklar"] == null
            ? []
            : List<int>.from(json["kayitolacaklar"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "grup_id": grupId,
        "grup_adi": grupAdi,
        "grup_yetkili": grupYetkili,
        "uyeler": uyeler,
        "aktif": aktif,
        "uyegrubulistesi": uyegrubulistesi == null
            ? []
            : List<dynamic>.from(uyegrubulistesi!.map((x) => x)),
        "kayitolacaklar": kayitolacaklar == null
            ? []
            : List<dynamic>.from(kayitolacaklar!.map((x) => x)),
      };
}

class RandevuZamanlayici {
  final int gun; // 0=Sunday, 1=Monday, ..., 6=Saturday
  final String baslangicSaati; // Örneğin: "09:45"
  final String bitisSaati; // Örneğin: "19:00"
  final int periyot; // Dakika cinsinden, örneğin: 30

  RandevuZamanlayici({
    required this.gun,
    required this.baslangicSaati,
    required this.bitisSaati,
    required this.periyot,
  });

  factory RandevuZamanlayici.fromMap(Map<String, dynamic> json) =>
      RandevuZamanlayici(
        gun: int.parse(json['gun']),
        baslangicSaati: json['baslangicsaati'],
        bitisSaati: json['bitissaati'],
        periyot: int.parse(json['periyot']),
      );

  Map<String, dynamic> toMap() => {
        "gun": gun,
        "baslangicsaati": baslangicSaati,
        "bitissaati": bitisSaati,
        "periyot": periyot,
      };

  @override
  String toString() {
    return 'RandevuZamanlayici(gun: $gun, baslangicSaati: $baslangicSaati, bitisSaati: $bitisSaati, periyot: $periyot)';
  }
}
