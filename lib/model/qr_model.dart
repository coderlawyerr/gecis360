import 'dart:convert';

class QR {
  String? status; // API'den gelen durum bilgisi
  List<String>? qrkodlar; // QR kodlarının listesi

  QR({this.status, this.qrkodlar});

  // JSON verisini sınıfa dönüştürmek için bir constructor
  QR.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    qrkodlar = json['qrkodlar'] != null
        ? List<String>.from(jsonDecode(json['qrkodlar'])) // JSON'dan listeye dönüştür
        : null;
  }

  // Sınıfı JSON formatına dönüştürmek için bir metot
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (qrkodlar != null) {
      data['qrkodlar'] = qrkodlar;
    }
    return data;
  }
}
