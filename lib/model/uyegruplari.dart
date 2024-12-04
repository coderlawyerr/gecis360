// models/uyegruplari.dart
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
