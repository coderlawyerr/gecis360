class RandevuZamanlayici {
  String? gun;
  String? baslangicsaati;
  String? bitissaati;
  String? periyot;

  RandevuZamanlayici(
      {this.gun, this.baslangicsaati, this.bitissaati, this.periyot});

  RandevuZamanlayici.fromJson(Map<String, dynamic> json) {
    gun = json['gun'];
    baslangicsaati = json['baslangicsaati'];
    bitissaati = json['bitissaati'];
    periyot = json['periyot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gun'] = this.gun;
    data['baslangicsaati'] = this.baslangicsaati;
    data['bitissaati'] = this.bitissaati;
    data['periyot'] = this.periyot;
    return data;
  }
}
