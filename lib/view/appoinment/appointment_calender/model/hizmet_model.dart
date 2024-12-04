// ignore_for_file: unnecessary_this

class HizmetModel {
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
  int? aktif;

  HizmetModel(
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
      this.aktif});

  HizmetModel.fromJson(Map<String, dynamic> json) {
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
    aktif = json['aktif'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =   <String, dynamic>{};
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
    data['aktif'] = this.aktif;
    return data;
  }
}


 