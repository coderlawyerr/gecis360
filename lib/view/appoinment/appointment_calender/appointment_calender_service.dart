import 'dart:convert';
import 'dart:developer';

import 'package:armiyaapp/model/usermodel.dart';
import 'package:armiyaapp/utils/constants.dart';
import 'package:armiyaapp/view/appoinment/appointment_calender/model/group_details.model.dart' as GroupDetailsModel;
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../data/app_shared_preference.dart';

import 'model/calender_model.dart';
import 'model/facility_model.dart';

final String baseURL = "https://$apiBaseUrl/api";

class AppointmentService {
  List<Randevu> existingAppointments = [];
  Future<List<FacilitySelectModel>?> fetchFacilities() async {
    SharedDataService sharedAppData = SharedDataService();
    UserModel? userModel = await sharedAppData.getLoginData();
    try {
      final response = await http.post(
        Uri.parse('$baseURL/randevu/olustur/index.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Accept-CharSet': 'utf-8'},
        body: {
          'tesislergetir': '1',
          'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
        },
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('API boş yanıt döndü.');
        }

        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        if (jsonResponse is List) {
          return jsonResponse.map((item) => FacilitySelectModel.fromJson(item)).toList();
        }
        return null;
      } else {
        log('Veri çekilemedi. Lütfen tekrar deneyin.');
        return null;
      }
    } catch (e) {
      print('Tesisleri alırken hata oluştu: $e');
      return null;
    }
  }

  Future<CalendarInfoModel?> fetchServiceDetails({
    required int selectedFacilityId,
    required List<int> selectedServiceIds,
  }) async {
    try {
      SharedDataService sharedAppData = SharedDataService();
      UserModel? userModel = await sharedAppData.getLoginData();
      final response = await http.post(
        Uri.parse('$baseURL/randevu/olustur/index.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'tesisid': selectedFacilityId.toString(),
          'hizmetsecim': selectedServiceIds.toString(), // Virgülle ayrılmış string
          'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
        },
      );

      if ((response.statusCode == 200 || response.statusCode == 200) && response.body.isNotEmpty) {
        if (response.body.isEmpty) {
          throw Exception('API boş yanıt döndü.');
        }

        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        log('fetchServiceDetails: jsonResponse: $jsonResponse');
        return CalendarInfoModel.fromJson(jsonResponse);
      } else {
        log('Servis detayları getirilemedi: ${response.toString()}');
        return null;
      }
    } catch (e) {
      log('Servis detayları getirilemedi: $e');
      throw Exception('Servis detayları getirilemedi: $e');
    }
  }

  Future<List<Hizmetler>?> fetchServices(int facilityId) async {
    try {
      SharedDataService sharedAppData = SharedDataService();
      UserModel? userModel = await sharedAppData.getLoginData();

      final response = await http.post(
        Uri.parse('$baseURL/randevu/olustur/index.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'tesissecim': facilityId.toString(),
          'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        CalendarInfoModel model = CalendarInfoModel.fromJson(jsonResponse);

        return model.hizmetler;
      } else {
        throw Exception('Hizmetler API isteği başarısız oldu.');
      }
    } catch (e) {
      print('Hizmetler alınırken hata oluştu: $e');
      return null;
    }
  }

  // Saat dilimlerinin rengini belirleme fonksiyonu
  Map<String, Color> kontrolEt({
    required int hizmetId,
    required List<Bilgi> selectedServices,
    required List<Randevu> existingAppointments,
    required int currentUserId,
    required DateTime? selectedDate,
    required List<int> selectedServiceIds,
    required Map<int, List<DateTime>> serviceTimeSlots,
    required List<Randevu> randevuList,
  }) {
    Map<String, Color> saatDurumlari = {};
    final existingAppointments = randevuList.where((r) {
      if (r.baslangictarihi == null) return false;
      return r.baslangictarihi!.year == selectedDate!.year &&
          r.baslangictarihi!.month == selectedDate.month &&
          r.baslangictarihi!.day == selectedDate.day &&
          selectedServiceIds.contains(r.hizmetid);
    }).toList();
    // Belirli bir hizmet için saat dilimlerini al
    List<DateTime> timeSlots = serviceTimeSlots[hizmetId] ?? [];

    // Hizmet bilgilerini al
    Bilgi? service = selectedServices.firstWhere((s) => s.hizmetId == hizmetId); //firstWhereOrNull((s) => s.hizmetId == hizmetId);

    bool isServiceUnavailable = false;
    if (service.saatlikKapasite == 0 || service.ozelalan == 1) {
      isServiceUnavailable = true;
    }

    for (var timeSlot in timeSlots) {
      String formattedTime = DateFormat('HH:mm').format(timeSlot);
      if (isServiceUnavailable) {
        saatDurumlari[formattedTime] = Colors.red; // Hizmet Kullanılamaz
      } else {
        bool isBookedByUser = existingAppointments.any((r) => r.hizmetid == hizmetId && r.baslangicsaati == formattedTime && r.kullaniciid == currentUserId);

        bool isBookedByOthers = existingAppointments.any((r) => r.hizmetid == hizmetId && r.baslangicsaati == formattedTime && r.kullaniciid != currentUserId);

        if (isBookedByUser) {
          saatDurumlari[formattedTime] = Colors.green; // Kullanıcı tarafından alınmış
        } else if (isBookedByOthers) {
          saatDurumlari[formattedTime] = Colors.red; // Başkaları tarafından alınmış
        } else {
          saatDurumlari[formattedTime] = Colors.blue.shade100; // Müsait
        }
      }
    }

    return saatDurumlari;
  }

  // Saat Dilimini Seçme Fonksiyonu
  void selectTimeSlot(
      DateTime timeSlot, int serviceId, int currentUserId, List<Bilgi> selectedServices, List<Randevu> existingAppointments, Map<int, int> servicePeriyots) {
    // Öncelikle hizmetin saatlik kapasitesini kontrol edin
    Bilgi? service = selectedServices.firstWhere((s) => s.hizmetId == serviceId);

    if (service.saatlikKapasite == 0 || service.ozelalan == 1) {
      // Bu hizmet için randevu alınamaz
      // Kullanıcıya bilgi verebilirsiniz
      return;
    }

    // Burada randevu oluşturma işlemini gerçekleştirin
    // Örneğin, API'ye randevu oluşturma isteği gönderin

    // Örnek olarak, randevuyu mevcut randevulara ekleyelim
    String formattedTime = DateFormat('HH:mm').format(timeSlot);
    Randevu newAppointment = Randevu(
      baslangictarihi: timeSlot,
      bitistarihi: timeSlot.add(Duration(minutes: servicePeriyots[serviceId]!)),
      formatlibaslangictarihi: DateFormat('dd.MM.yyyy').format(timeSlot), // Formatlı tarih
      formatlibitistarihi: DateFormat('dd.MM.yyyy').format(timeSlot.add(Duration(minutes: servicePeriyots[serviceId]!))),
      baslangicsaati: formattedTime,
      bitissaati: DateFormat('HH:mm').format(timeSlot.add(Duration(minutes: servicePeriyots[serviceId]!))),
      kullaniciid: currentUserId,
      hizmetid: serviceId,
      hizmetad: selectedServices.firstWhere((s) => s.hizmetId == serviceId).hizmetAd,
      kapasite: selectedServices.firstWhere((s) => s.hizmetId == serviceId).saatlikKapasite,
    );

    existingAppointments.add(newAppointment);
    generateTimeSlots(
      selectedDate: timeSlot,
      serviceId: serviceId,
      currentUserId: currentUserId,
      selectedServices: selectedServices,
      existingAppointments: existingAppointments,
      servicePeriyots: servicePeriyots,
    ); // Saat dilimlerini yeniden oluştur
    // Seçilen saat dilimini onayla
  }

  List<DateTime>? generateTimeSlots(
      {required DateTime? selectedDate,
      required int serviceId,
      required int currentUserId,
      required List<Bilgi> selectedServices,
      required List<Randevu> existingAppointments,
      required Map<int, int> servicePeriyots}) {
    if (selectedServices.isEmpty || selectedDate == null) return null;
    // Mevcut saat dilimlerini temizle

    for (var hizmet in selectedServices) {
      if (hizmet.zamanlayiciList == null || hizmet.zamanlayiciList?.isEmpty == true) {
        continue;
      }
      // Haftanın günü (1=Monday, ..., 7=Sunday) → Pazar 0 olmalı
      int selectedWeekday = selectedDate.weekday % 7;

      // Bu güne ait zamanlayıcıyı bulma
      final schedule = hizmet.zamanlayiciList!.firstWhere(
        (zaman) => zaman.gun == selectedWeekday,
        orElse: () => RandevuZamanlayici(gun: selectedWeekday, baslangicSaati: '09:00', bitisSaati: '17:00', periyot: 30), // Varsayılan değerler
      );
      // Periyot değerini al
      final periyot = schedule.periyot;
      servicePeriyots[hizmet.hizmetId!] = periyot;
      // Başlangıç ve bitiş saatlerini parse etme
      final baslangicParts = schedule.baslangicSaati.split(':');
      final bitisParts = schedule.bitisSaati.split(':');
      if (baslangicParts.length != 2 || bitisParts.length != 2) {
        print('Saat formatı hatalı: baslangic = ${schedule.baslangicSaati}, bitis = ${schedule.bitisSaati}');
        continue;
      }
      final baslangicSaat = int.tryParse(baslangicParts[0]) ?? 0;
      final baslangicDakika = int.tryParse(baslangicParts[1]) ?? 0;
      final bitisSaat = int.tryParse(bitisParts[0]) ?? 0;
      final bitisDakika = int.tryParse(bitisParts[1]) ?? 0;

      DateTime startTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        baslangicSaat,
        baslangicDakika,
      );

      DateTime endTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        bitisSaat,
        bitisDakika,
      );
      List<String> slots = [];
      while (startTime.isBefore(endTime)) {
        String formatted = DateFormat('HH:mm').format(startTime);
        slots.add(formatted);
        startTime = startTime.add(Duration(minutes: periyot));
      }
      // Mevcut randevulara göre dolu saat dilimlerini çıkarma
      Set<String> bookedSlots = existingAppointments.where((r) => r.hizmetid == hizmet.hizmetId).map((r) => r.baslangicsaati ?? '').toSet();

      Set<String> availableSlots = slots.toSet(); // Tüm slotları göster

      // Zaman dilimlerini DateTime nesnelerine çevirme
      List<DateTime> finalTimeSlots = availableSlots.map((slot) {
        final parts = slot.split(':');
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      }).toList()
        ..sort(); // Saat dilimlerini sırala

      return finalTimeSlots;
    }
    return null;
  }

  Future<GroupDetailsModel.GroupDetailsResponse?> fetchGroupDetails({
    required int selectedFacilityId,
    required List<int> selectedServiceIds,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/randevu/olustur/index.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'tesisid': selectedFacilityId.toString(),
          'hizmetsecim': selectedServiceIds.toString(), // Virgülle ayrılmış string
          'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
        },
      );

      if ((response.statusCode == 200 || response.statusCode == 200) && response.body.isNotEmpty) {
        if (response.body.isEmpty) {
          throw Exception('API boş yanıt döndü.');
        }

        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        log('fetchServiceDetails: jsonResponse: $jsonResponse');
        return GroupDetailsModel.GroupDetailsResponse.fromJson(jsonResponse);
      } else {
        log('Servis detayları getirilemedi: ${response.toString()}');
        return null;
      }
    } catch (e) {
      log('Servis detayları getirilemedi: $e');
      throw Exception('Servis detayları getirilemedi: $e');
    }
  }
}
