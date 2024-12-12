import 'package:armiyaapp/model/cancelappointment.dart';
import 'package:flutter/material.dart';

class IptalRandevuProvider with ChangeNotifier {
  List<Mycancelappointment> iptaledilenrandevum = [];

  iptalEdilenRandevuGuncelle(List<Mycancelappointment> list) {
    iptaledilenrandevum = list;
    notifyListeners();
  }

  iptalEdilenRandevuEkle(Mycancelappointment randevu) {
    iptaledilenrandevum.add(randevu);
    notifyListeners();
  }
}
