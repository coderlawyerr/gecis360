class kayit {
  String? tesisAd;
  String? hizmetAd;
  String? kullaniciIsimsoyisim;
  String? girisTarihi;
  String? cikisTarihi;
  String? gecirilenSureRenk;
  String? gecirilenSure;

  kayit(
      {this.tesisAd,
      this.hizmetAd,
      this.kullaniciIsimsoyisim,
      this.girisTarihi,
      this.cikisTarihi,
      this.gecirilenSureRenk,
      this.gecirilenSure});

  kayit.fromJson(Map<String, dynamic> json) {
    tesisAd = json['tesis_ad'];
    hizmetAd = json['hizmet_ad'];
    kullaniciIsimsoyisim = json['kullanici_isimsoyisim'];
    girisTarihi = json['giris_tarihi'];
    cikisTarihi = json['cikis_tarihi'];
    gecirilenSureRenk = json['gecirilen_sure_renk'];
    gecirilenSure = json['gecirilen_sure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tesis_ad'] = this.tesisAd;
    data['hizmet_ad'] = this.hizmetAd;
    data['kullanici_isimsoyisim'] = this.kullaniciIsimsoyisim;
    data['giris_tarihi'] = this.girisTarihi;
    data['cikis_tarihi'] = this.cikisTarihi;
    data['gecirilen_sure_renk'] = this.gecirilenSureRenk;
    data['gecirilen_sure'] = this.gecirilenSure;
    return data;
  }
}