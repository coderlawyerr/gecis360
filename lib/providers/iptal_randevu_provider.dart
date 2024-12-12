// import 'package:armiyaapp/model/cancelappointment.dart';
// import 'package:flutter/material.dart';

// class IptalRandevuProvider with ChangeNotifier {
//   List<Mycancelappointment> iptaledilenrandevum = [];

//   iptalEdilenRandevuGuncelle(List<Mycancelappointment> list) {
//     iptaledilenrandevum = list;
//     notifyListeners();
//   }

//   iptalEdilenRandevuEkle(Mycancelappointment randevu) {
//     iptaledilenrandevum.add(randevu);
//     notifyListeners();
//   }
// }


import 'package:flutter/material.dart';
import 'package:armiyaapp/model/cancelappointment.dart';

class IptalRandevuProvider with ChangeNotifier {
  List<Mycancelappointment> _iptaledilenrandevum = [];

  List<Mycancelappointment> get iptaledilenrandevum => _iptaledilenrandevum;

  void iptalEdilenRandevuGuncelle(List<Mycancelappointment> list) {
    _iptaledilenrandevum = list;
    notifyListeners();
  }

  void iptalEdilenRandevuEkle(Mycancelappointment randevu) {
    _iptaledilenrandevum.add(randevu);
    notifyListeners();
  }
}