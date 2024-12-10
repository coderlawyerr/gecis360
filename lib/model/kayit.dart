class kayit {
  String? tesisAd;
  String? hizmetAd;
  String? kullaniciIsimsoyisim;
  String? durumRenk;
  String? durum;

  kayit({this.tesisAd, this.hizmetAd, this.kullaniciIsimsoyisim, this.durumRenk, this.durum});

  kayit.fromJson(Map<String, dynamic> json) {
    tesisAd = json['tesis_ad'];
    hizmetAd = json['hizmet_ad'];
    kullaniciIsimsoyisim = json['kullanici_isimsoyisim'];
    durumRenk = json['durum_renk'];
    durum = json['durum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tesis_ad'] = this.tesisAd;
    data['hizmet_ad'] = this.hizmetAd;
    data['kullanici_isimsoyisim'] = this.kullaniciIsimsoyisim;
    data['durum_renk'] = this.durumRenk;
    data['durum'] = this.durum;
    return data;
  }
}
