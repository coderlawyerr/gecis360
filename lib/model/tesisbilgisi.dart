class Tesisbilgisi {
  int? tesisId;
  String? tesisAd;
  String? tesisTel;
  String? tesisEposta;
  String? tesisAdres;
  String? yetkiliAdisoyadi;
  String? yetkiliTel;
  String? yetkiliEposta;
  int? aktifGunsayisi;
  String? girisYontemi;
  String? hizmetler;
  // Null? masterqr;
  int? aktif;

  Tesisbilgisi(
      {this.tesisId,
      this.tesisAd,
      this.tesisTel,
      this.tesisEposta,
      this.tesisAdres,
      this.yetkiliAdisoyadi,
      this.yetkiliTel,
      this.yetkiliEposta,
      this.aktifGunsayisi,
      this.girisYontemi,
      this.hizmetler,
      // this.masterqr,
      this.aktif});

  Tesisbilgisi.fromJson(Map<String, dynamic> json) {
    tesisId = json['tesis_id'];
    tesisAd = json['tesis_ad'];
    tesisTel = json['tesis_tel'];
    tesisEposta = json['tesis_eposta'];
    tesisAdres = json['tesis_adres'];
    yetkiliAdisoyadi = json['yetkili_adisoyadi'];
    yetkiliTel = json['yetkili_tel'];
    yetkiliEposta = json['yetkili_eposta'];
    aktifGunsayisi = json['aktif_gunsayisi'];
    girisYontemi = json['giris_yontemi'];
    hizmetler = json['hizmetler'];
    // masterqr = json['masterqr'];
    aktif = json['aktif'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tesis_id'] = this.tesisId;
    data['tesis_ad'] = this.tesisAd;
    data['tesis_tel'] = this.tesisTel;
    data['tesis_eposta'] = this.tesisEposta;
    data['tesis_adres'] = this.tesisAdres;
    data['yetkili_adisoyadi'] = this.yetkiliAdisoyadi;
    data['yetkili_tel'] = this.yetkiliTel;
    data['yetkili_eposta'] = this.yetkiliEposta;
    data['aktif_gunsayisi'] = this.aktifGunsayisi;
    data['giris_yontemi'] = this.girisYontemi;
    data['hizmetler'] = this.hizmetler;
    // data['masterqr'] = this.masterqr;
    data['aktif'] = this.aktif;
    return data;
  }
}
