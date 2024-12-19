// class PassiveModel {
//   int? randevuId;
//   int? kullaniciId;
//   Null? kullaniciadi;
//   Null? ustkullaniciId;
//   Null? misafirAdsoyad;
//   Null? misafirTel;
//   Null? misafirTcno;
//   Null? misafirEposta;
//   int? misafirDurum;
//   int? tesisId;
//   int? hizmetId;
//   String? baslangicTarihi;
//   String? bitisTarihi;
//   String? olusturmaTarihi;
//   Null? qrID;
//   int? aktif;
//   int? iptaldurumu;
//   int? randevuyaGeldimi;
//   Null? detaylar;
//   String? timestamp;

//   PassiveModel(
//       {this.randevuId,
//       this.kullaniciId,
//       this.kullaniciadi,
//       this.ustkullaniciId,
//       this.misafirAdsoyad,
//       this.misafirTel,
//       this.misafirTcno,
//       this.misafirEposta,
//       this.misafirDurum,
//       this.tesisId,
//       this.hizmetId,
//       this.baslangicTarihi,
//       this.bitisTarihi,
//       this.olusturmaTarihi,
//       this.qrID,
//       this.aktif,
//       this.iptaldurumu,
//       this.randevuyaGeldimi,
//       this.detaylar,
//       this.timestamp});

//   PassiveModel.fromJson(Map<String, dynamic> json) {
//     randevuId = json['randevu_id'];
//     kullaniciId = json['kullanici_id'];
//     kullaniciadi = json['kullaniciadi'];
//     ustkullaniciId = json['ustkullanici_id'];
//     misafirAdsoyad = json['misafir_adsoyad'];
//     misafirTel = json['misafir_tel'];
//     misafirTcno = json['misafir_tcno'];
//     misafirEposta = json['misafir_eposta'];
//     misafirDurum = json['misafir_durum'];
//     tesisId = json['tesis_id'];
//     hizmetId = json['hizmet_id'];
//     baslangicTarihi = json['baslangic_tarihi'];
//     bitisTarihi = json['bitis_tarihi'];
//     olusturmaTarihi = json['olusturma_tarihi'];
//     qrID = json['qrID'];
//     aktif = json['aktif'];
//     iptaldurumu = json['iptaldurumu'];
//     randevuyaGeldimi = json['randevuya_geldimi'];
//     detaylar = json['detaylar'];
//     timestamp = json['timestamp'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['randevu_id'] = this.randevuId;
//     data['kullanici_id'] = this.kullaniciId;
//     data['kullaniciadi'] = this.kullaniciadi;
//     data['ustkullanici_id'] = this.ustkullaniciId;
//     data['misafir_adsoyad'] = this.misafirAdsoyad;
//     data['misafir_tel'] = this.misafirTel;
//     data['misafir_tcno'] = this.misafirTcno;
//     data['misafir_eposta'] = this.misafirEposta;
//     data['misafir_durum'] = this.misafirDurum;
//     data['tesis_id'] = this.tesisId;
//     data['hizmet_id'] = this.hizmetId;
//     data['baslangic_tarihi'] = this.baslangicTarihi;
//     data['bitis_tarihi'] = this.bitisTarihi;
//     data['olusturma_tarihi'] = this.olusturmaTarihi;
//     data['qrID'] = this.qrID;
//     data['aktif'] = this.aktif;
//     data['iptaldurumu'] = this.iptaldurumu;
//     data['randevuya_geldimi'] = this.randevuyaGeldimi;
//     data['detaylar'] = this.detaylar;
//     data['timestamp'] = this.timestamp;
//     return data;
//   }
// }

class PassiveModel {
  int? randevuId;
  int? kullaniciId;
  String? kullaniciadi; // Null yerine String? yapıldı.
  int? ustkullaniciId;
  String? misafirAdsoyad; // Null yerine String? yapıldı.
  String? misafirTel; // Null yerine String? yapıldı.
  String? misafirTcno; // Null yerine String? yapıldı.
  String? misafirEposta; // Null yerine String? yapıldı.
  int? misafirDurum;
  int? tesisId;
  int? hizmetId;
  String? baslangicTarihi;
  String? bitisTarihi;
  String? olusturmaTarihi;
  String? qrID; // Null yerine String? yapıldı.
  int? aktif;
  int? iptaldurumu;
  int? randevuyaGeldimi;
  String? detaylar; // Null yerine String? yapıldı.
  String? timestamp;

  PassiveModel({
    this.randevuId,
    this.kullaniciId,
    this.kullaniciadi,
    this.ustkullaniciId,
    this.misafirAdsoyad,
    this.misafirTel,
    this.misafirTcno,
    this.misafirEposta,
    this.misafirDurum,
    this.tesisId,
    this.hizmetId,
    this.baslangicTarihi,
    this.bitisTarihi,
    this.olusturmaTarihi,
    this.qrID,
    this.aktif,
    this.iptaldurumu,
    this.randevuyaGeldimi,
    this.detaylar,
    this.timestamp,
  });

  PassiveModel.fromJson(Map<String, dynamic> json) {
    randevuId = json['randevu_id'] as int?;
    kullaniciId = json['kullanici_id'] as int?;
    kullaniciadi = json['kullaniciadi'] as String?; // Tür dönüşümü yapıldı.
    ustkullaniciId = json['ustkullanici_id'] as int?;
    misafirAdsoyad = json['misafir_adsoyad'] as String?;
    misafirTel = json['misafir_tel'] as String?;
    misafirTcno = json['misafir_tcno'] as String?;
    misafirEposta = json['misafir_eposta'] as String?;
    misafirDurum = json['misafir_durum'] as int?;
    tesisId = json['tesis_id'] as int?;
    hizmetId = json['hizmet_id'] as int?;
    baslangicTarihi = json['baslangic_tarihi'] as String?;
    bitisTarihi = json['bitis_tarihi'] as String?;
    olusturmaTarihi = json['olusturma_tarihi'] as String?;
    qrID = json['qr_id'] as String?;
    aktif = json['aktif'] as int?;
    iptaldurumu = json['iptaldurumu'] as int?;
    randevuyaGeldimi = json['randevuya_geldimi'] as int?;
    detaylar = json['detaylar'] as String?;
    timestamp = json['timestamp'] as String?;
  }
}
