// class CalenderModel {
//     final List<Bilgi>? bilgi;
//     final List<Secilisaatler>? secilisaatler;
//     final List<Randevu>? randevu;
//     final List<Uyegruplari>? uyegruplari;
//     final List<int>? kayitolacaklar;

//     CalenderModel({
//         this.bilgi,
//         this.secilisaatler,
//         this.randevu,
//         this.uyegruplari,
//         this.kayitolacaklar,
//     });

// }

// class Bilgi {
//     final int? hizmetId;
//     final Hizmet? hizmetAd;
//     final String? hizmetTuru;
//     final int? saatlikKapasite;
//     final String? randevuZamanlayici;
//     final int? ozelalan;
//     final int? limitsizkapasite;
//     final int? misafirKabul;
//     final int? grupRandevusu;
//     final int? randevusuzGiris;
//     final int? gunlukGirissayisi;
//     final int? kullanimSuresi;
//     final int? aktif;

//     Bilgi({
//         this.hizmetId,
//         this.hizmetAd,
//         this.hizmetTuru,
//         this.saatlikKapasite,
//         this.randevuZamanlayici,
//         this.ozelalan,
//         this.limitsizkapasite,
//         this.misafirKabul,
//         this.grupRandevusu,
//         this.randevusuzGiris,
//         this.gunlukGirissayisi,
//         this.kullanimSuresi,
//         this.aktif,
//     });

// }

// enum Hizmet {
//     HAL_SAHA,
//     YZME_HAVUZU
// }

// class Randevu {
//     final DateTime? baslangictarihi;
//     final DateTime? bitistarihi;
//     final String? formatlibaslangictarihi;
//     final String? formatlibitistarihi;
//     final String? baslangicsaati;
//     final String? bitissaati;
//     final int? kullaniciid;
//     final int? hizmetid;
//     final Hizmet? hizmetad;
//     final int? kapasite;

//     Randevu({
//         this.baslangictarihi,
//         this.bitistarihi,
//         this.formatlibaslangictarihi,
//         this.formatlibitistarihi,
//         this.baslangicsaati,
//         this.bitissaati,
//         this.kullaniciid,
//         this.hizmetid,
//         this.hizmetad,
//         this.kapasite,
//     });

// }

// class Secilisaatler {
//     final int? hizmetId;
//     final Hizmet? hizmetad;
//     final String? gun;
//     final String? baslangicsaati;
//     final String? bitissaati;
//     final String? periyot;

//     Secilisaatler({
//         this.hizmetId,
//         this.hizmetad,
//         this.gun,
//         this.baslangicsaati,
//         this.bitissaati,
//         this.periyot,
//     });

// }

// class Uyegruplari {
//     final int? grupId;
//     final String? grupAdi;
//     final String? grupYetkili;
//     final String? uyeler;
//     final int? aktif;
//     final List<int>? uyegrubulistesi;
//     final List<int>? kayitolacaklar;

//     Uyegruplari({
//         this.grupId,
//         this.grupAdi,
//         this.grupYetkili,
//         this.uyeler,
//         this.aktif,
//         this.uyegrubulistesi,
//         this.kayitolacaklar,
//     });

// }
