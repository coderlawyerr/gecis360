// models/randevu.dart
class Randevu {
  final DateTime? baslangicTarihi;
  final DateTime? bitisTarihi;
  final String? formatlibaslangictarihi;
  final String? formatlibitistarihi;
  final String? baslangicSaati;
  final String? bitisSaati;
  final int? kullaniciId;
  final int ? misafirdurumu;
  final int? hizmetId;
  final String? hizmetAd;
  final int? kapasite;
  

  Randevu({
    this.baslangicTarihi,
    this.bitisTarihi,
    this.formatlibaslangictarihi,
    this.formatlibitistarihi,
    this.baslangicSaati,
    this.bitisSaati,
    this.kullaniciId,
    this.misafirdurumu,///////son ekelnene 
    this.hizmetId,
    this.hizmetAd,
    this.kapasite,
  });

  factory Randevu.fromMap(Map<String, dynamic> json) => Randevu(
        baslangicTarihi: json["baslangictarihi"] == null ? null : DateTime.parse(json["baslangictarihi"]),
        bitisTarihi: json["bitistarihi"] == null ? null : DateTime.parse(json["bitistarihi"]),
        formatlibaslangictarihi: json["formatlibaslangictarihi"],
        formatlibitistarihi: json["formatlibitistarihi"],
        baslangicSaati: json["baslangicsaati"],
        bitisSaati: json["bitissaati"],
        kullaniciId: json["kullaniciid"],
          misafirdurumu :json["misafirdurumu"],
        hizmetId: json["hizmetid"],
      
        hizmetAd: json["hizmetad"],
        kapasite: json["kapasite"],
      );

  Map<String, dynamic> toMap() => {
        "baslangictarihi": baslangicTarihi?.toIso8601String(),
        "bitistarihi": bitisTarihi?.toIso8601String(),
        "formatlibaslangictarihi": formatlibaslangictarihi,
        "formatlibitistarihi": formatlibitistarihi,
        "baslangicsaati": baslangicSaati,
        "bitissaati": bitisSaati,
        "kullaniciid": kullaniciId,
        "misafirdurumu":misafirdurumu,
        "hizmetid": hizmetId, 

        "hizmetad": hizmetAd,
        "kapasite": kapasite,
      };
}
