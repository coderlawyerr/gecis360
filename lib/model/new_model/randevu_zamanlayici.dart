// models/randevu_zamanlayici.dart
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

  factory RandevuZamanlayici.fromJson(Map<String, dynamic> json) {
    return RandevuZamanlayici(
      gun: int.parse(json['gun']),
      baslangicSaati: json['baslangicsaati'],
      bitisSaati: json['bitissaati'],
      periyot: int.parse(json['periyot']),
    );
  }
}
