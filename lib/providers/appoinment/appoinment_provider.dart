// appointment_provider.dart

import 'dart:convert';
import 'package:armiyaapp/utils/constants.dart';
import 'package:armiyaapp/view/appoinment/appointment_calender/model/facility_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:armiyaapp/model/new_model/newmodel.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../view/appoinment/appointment_calender/model/randevu_model.dart';

class AppointmentProvider with ChangeNotifier {
// Belirtilen hizmetin kapasitesini azaltan bir fonksiyon
  void decreaseCapacity(int serviceId) {
    // İlgili hizmeti _selectedServices listesinden bul
    final service = _selectedServices.firstWhere((s) => s.hizmetId == serviceId);

    // Eğer hizmetin saatlik kapasitesi null değilse ve sıfırdan büyükse
    if (service.saatlikKapasite != null && service.saatlikKapasite! > 0) {
      // Saatlik kapasiteyi bir azalt
      service.saatlikKapasite = service.saatlikKapasite! - 1;
      // Dinleyicilere değişiklik olduğunu bildir (UI'yi güncellemek için)
      notifyListeners();
    }
  }

  DateTime? confirmedTimeSlot; // Onaylanan saat
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<DateTime> confirmedTimeSlots = [];

  // Tesis ve hizmet listeleri
  List<FacilitySelectModel> _facilities = [];

  List<FacilitySelectModel> get facilities => _facilities;

  // Saat dilimi renklerini tutmak için bir harita
  Map<String, Color> slotColors = {};

  get activeAppointments => null;

  void updateSlotColor(int serviceIndex, int slotIndex, Color color) {
    final service = selectedServices[serviceIndex];
    final timeSlot = serviceTimeSlots[service.hizmetId]?[slotIndex];

    if (timeSlot != null) {
      final formattedStartTime = DateFormat('HH:mm').format(timeSlot);
      slotColors[formattedStartTime] = color; // Rengi güncelle
      print("Renk Değişti: $color");
      notifyListeners(); // Dinleyicileri bilgilendir
    }
  }

  List<Bilgi> _services = [];

  List<Bilgi> get services => _services;
  List<Bilgi> _selectedServices = [];

  List<Bilgi> get selectedServices => _selectedServices;

  // Her hizmete ait saat dilimlerini saklamak için
  Map<int, List<DateTime>> _serviceTimeSlots = {};

  Map<int, List<DateTime>> get serviceTimeSlots => _serviceTimeSlots;

  // Her hizmetin periyot değerlerini saklamak için
  Map<int, int> _servicePeriyots = {};

  Map<int, int> get servicePeriyots => _servicePeriyots;
  List<Randevu> _existingAppointments = [];
  List<RandevuModel> allAppointments = [];

  List<Randevu> get existingAppointments => _existingAppointments;
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;
  int aktifGunSayisi = 0; // Aktif gün sayısını buraya ekleyin veya dinamik olarak alın
  // Seçili tesis ve hizmet ID'leri
  int? _selectedFacilityId;

  int? get selectedFacilityId => _selectedFacilityId;
  List<int> _selectedServiceIds = [];

  List<int> get selectedServiceIds => _selectedServiceIds;

  // Durum değişkenleri
  bool _showCalendar = false;

  bool get showCalendar => _showCalendar;
  bool _showTimeSlots = false;

  bool get showTimeSlots => _showTimeSlots;

  // API Token
  final String _token = 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as';

  // CalendarController
  final CalendarController calendarController = CalendarController();

  // Mevcut Kullanıcı ID'si (Örnek olarak 1)
  final int currentUserId = 1; // Gerçek uygulamada, bu değeri kimlik doğrulama sisteminden alın
  // Tesisleri API'den Çekme
  Future<void> fetchFacilities() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('https://$apiBaseUrl/api/randevu/olustur/index.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Accept-CharSet': 'utf-8'},
        body: {
          'tesislergetir': '1',
          'token': _token,
        },
      );
      print('HTTP Status Code: ${response.statusCode}');
      print('HTTP Response Body: ${response.body}');
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('API boş yanıt döndü.');
        }

        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        if (jsonResponse is List) {
          _facilities = jsonResponse.map((item) => FacilitySelectModel.fromJson(item)).toList();
          setSelectedFacility(null);
        } else {
          throw Exception('Beklenen formatta veri gelmedi.');
        }
      } else {
        throw Exception('Veri çekilemedi. Lütfen tekrar deneyin.');
      }
    } catch (e) {
      print('Tesisleri alırken hata oluştu: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Seçilen Tesis'e Bağlı Hizmetleri API'den Çekme
  Future<void> fetchServices(int facilityId) async {
    _isLoading = true;

    // Temizleme işlemleri
    _services = [];
    _selectedServiceIds = [];
    _selectedServices = [];
    _serviceTimeSlots = {};
    _servicePeriyots = {};
    _selectedDate = null;
    _existingAppointments = [];
    _showCalendar = false;
    _showTimeSlots = false;
    notifyListeners();
    try {
      var url = 'https://$apiBaseUrl/api/randevu/olustur/index.php';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'tesissecim': facilityId.toString(),
          'token': _token,
        },
      );
      print('Hizmetler API HTTP Status Code: ${response.statusCode}');
      print('Hizmetler API Response Body: ${response.body}');
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('API boş yanıt döndü.');
        }
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['hizmetler'] != null && jsonResponse['hizmetler'] is List) {
          _services = List<Bilgi>.from(
            jsonResponse['hizmetler'].map((x) => Bilgi.fromMap(x)),
          ).where((e) => e.misafirKabul == 1).toList();
          if (_services.isNotEmpty) {
            _showCalendar = false;
          } else {
            _showCalendar = false;
          }
        } else {
          throw Exception('Hizmetler listesi beklenen formatta değil.');
        }
      } else {
        throw Exception('Hizmetler API isteği başarısız oldu.');
      }
    } catch (e) {
      print('Hizmetler API hatası: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  // Seçilen Hizmetleri Ayarlama
  void setSelectedServices(List<int> serviceIds) {
    _selectedServiceIds = serviceIds;
    _selectedServices = _services.where((s) => serviceIds.contains(s.hizmetId)).toList();
    _showCalendar = serviceIds.isNotEmpty;
    _showTimeSlots = false;
    _selectedDate = null;
    _serviceTimeSlots = {};
    _servicePeriyots = {};
    _existingAppointments = [];
    notifyListeners();
  }

  // Seçilen Tesis
  void setSelectedFacility(int? facilityId) {
    _selectedFacilityId = facilityId;
    notifyListeners();
  }

  // Seçilen Tarihi Ayarlama
  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Seçilen Tarihi Ayarlama ve Saat Dilimlerini Gösterme
  Future<void> selectDate(BuildContext context, DateTime selected) async {
    // Geçmiş tarihi kontrol et (bugün ve geleceği seçebilir)
    DateTime today = DateTime.now();
    DateTime? maxDate;
    if (aktifGunSayisi > 0) {
      maxDate = today.add(Duration(days: aktifGunSayisi));
    }
    if (selected.isBefore(today.subtract(const Duration(days: 1))) || (maxDate != null && selected.isAfter(maxDate))) {
      // Geçmiş veya izin verilen maksimum tarihten sonra bir tarih seçildi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu tarih seçilemez.'),
        ),
      );
      return;
    }
    _selectedDate = selected;
    _showTimeSlots = true;
    _showCalendar = false;
    notifyListeners();
    try {
      await fetchServiceDetails();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Servis detayları alınamadı: $e'),
        ),
      );
    }
  }

  // Seçilen Tesis ve Hizmetlere Bağlı Servis Detaylarını Çekme
  Future<void> fetchServiceDetails() async {
    if (_selectedServiceIds.isEmpty || _selectedFacilityId == null) {
      throw Exception('Lütfen bir tesis ve en az bir hizmet seçiniz.');
    }
    try {
      final response = await http.post(
        Uri.parse('https://$apiBaseUrl/api/randevu/olustur/index.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'tesisid': _selectedFacilityId.toString(),
          'hizmetsecim': _selectedServiceIds.toString(), // Virgülle ayrılmış string
          'token': _token,
        },
      );
      print('TimeSlotsPage Gelen Yanıt: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('API boş yanıt döndü.');
        }
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['bilgi'] != null && jsonResponse['bilgi'] is List) {
          _selectedServices = List<Bilgi>.from(jsonResponse['bilgi'].map((x) => Bilgi.fromMap(x)));

          // 'randevu' listesi içerisinden mevcut randevuları çekme
          if (jsonResponse['randevu'] != null && jsonResponse['randevu'] is List) {
            List<Randevu> randevuList = List<Randevu>.from(jsonResponse['randevu'].map((x) => Randevu.fromMap(x)));

            _existingAppointments = randevuList.where((r) {
              if (r.baslangictarihi == null) return false;
              return r.baslangictarihi?.year == _selectedDate?.year &&
                  r.baslangictarihi?.month == _selectedDate?.month &&
                  r.baslangictarihi?.day == _selectedDate?.day &&
                  _selectedServiceIds.contains(r.hizmetid);
            }).toList();
          }
          generateTimeSlots();
        } else {
          throw Exception('Beklenen formatta veri gelmedi.');
        }
      } else {
        throw Exception('Servis detayları getirilemedi.');
      }
    } catch (e) {
      print('Hata: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Her hizmet için ayrı saat dilimleri oluşturma
  Map<int, List<DateTime>> generateTimeSlots() {
    if (_selectedServices.isEmpty || _selectedDate == null) return {};
    // Mevcut saat dilimlerini temizle
    _serviceTimeSlots.clear();
    _servicePeriyots.clear();
    for (var hizmet in _selectedServices) {
      if (hizmet.zamanlayiciList == null || hizmet.zamanlayiciList!.isEmpty) {
        continue;
      }
      // Haftanın günü (1=Monday, ..., 7=Sunday) → Pazar 0 olmalı
      int selectedWeekday = _selectedDate!.weekday % 7;

      // Bu güne ait zamanlayıcıyı bulma
      final schedule = hizmet.zamanlayiciList!.firstWhere(
        (zaman) => zaman.gun == selectedWeekday,
        orElse: () => RandevuZamanlayici(
            gun: selectedWeekday, baslangicSaati: '09:00', bitisSaati: '17:00', periyot: 30), // Varsayılan değerler
      );
      // Periyot değerini al
      final periyot = schedule.periyot;
      _servicePeriyots[hizmet.hizmetId!] = periyot;
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
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        baslangicSaat,
        baslangicDakika,
      );

      DateTime endTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
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
      Set<String> bookedSlots =
          _existingAppointments.where((r) => r.hizmetid == hizmet.hizmetId).map((r) => r.baslangicsaati ?? '').toSet();

      Set<String> availableSlots = slots.toSet(); // Tüm slotları göster

      // Zaman dilimlerini DateTime nesnelerine çevirme
      List<DateTime> finalTimeSlots = availableSlots.map((slot) {
        final parts = slot.split(':');
        return DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      }).toList()
        ..sort(); // Saat dilimlerini sırala

      _serviceTimeSlots[hizmet.hizmetId!] = finalTimeSlots;
    }

    return _serviceTimeSlots;
  }

  void resetToCalendar() {
    _showTimeSlots = false; // Saat dilimlerini gizle
    _selectedDate = null; // Seçilen tarihi temizle
    _serviceTimeSlots = {}; // Hizmet saat dilimlerini temizle
    _servicePeriyots = {}; // Hizmet periyotlarını temizle
    notifyListeners(); // Dinleyicileri bilgilendir
  }

  void backToCalendar() {
    _showTimeSlots = false;
    calendarController.selectedDate = null;
    _showCalendar = true;
    notifyListeners();
  }

  // Saat seçimi widget'ı için
  Widget buildCalendar(BuildContext context) {
    return SfCalendar(
      controller: calendarController,
      onSelectionChanged: (calendarSelectionDetails) {
        DateTime? selected = calendarSelectionDetails.date;
        if (selected == null) return;

        print('Seçilen Tarih: $selected');

        // Geçmiş tarihi kontrol et (bugün ve geleceği seçebilir)
        DateTime today = DateTime.now();
        DateTime? maxDate;
        if (aktifGunSayisi > 0) {
          maxDate = today.add(Duration(days: aktifGunSayisi));
        }

        if (selected.isBefore(today.subtract(const Duration(days: 1))) ||
            (maxDate != null && selected.isAfter(maxDate))) {
          // Geçmiş veya izin verilen maksimum tarihten sonra bir tarih seçildi
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bu tarih seçilemez.'),
            ),
          );
          return;
        }

        // Tarihi seç ve saat dilimlerini göster
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          try {
            await selectDate(context, selected);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Servis detayları alınamadı: $e'),
              ),
            );
          }
        });
      },
      view: CalendarView.month,
      timeZone: 'Turkey Standard Time',
      timeSlotViewSettings: const TimeSlotViewSettings(timeFormat: 'HH:mm'),
      monthViewSettings: const MonthViewSettings(
        showTrailingAndLeadingDates: false, // Trailing ve leading tarihleri gizle
        dayFormat: 'd',
      ),
      minDate: DateTime.now(),
      maxDate: aktifGunSayisi > 0
          ? DateTime.now().add(Duration(days: aktifGunSayisi))
          : DateTime.now().add(const Duration(days: 365)),
      // aktifGunSayisi 0 ise 1 yıl
      monthCellBuilder: (BuildContext context, MonthCellDetails details) {
        DateTime date = details.date;
        DateTime today = DateTime.now();
        DateTime? maxDate;
        if (aktifGunSayisi > 0) {
          maxDate = today.add(Duration(days: aktifGunSayisi));
        }

        bool isSelectable = true;
        if (date.isBefore(today.subtract(const Duration(days: 1)))) {
          isSelectable = false;
        } else if (maxDate != null && date.isAfter(maxDate)) {
          isSelectable = false;
        }

        print('Date: $date, Selectable: $isSelectable');

        return Container(
          decoration: BoxDecoration(
            color: isSelectable ? Colors.white : Colors.grey[300],
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: Text(
              date.day.toString(),
              style: TextStyle(
                color: isSelectable ? Colors.black : Colors.grey,
                fontWeight: isSelectable ? FontWeight.normal : FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  // Saat dilimlerinin rengini belirleme fonksiyonu
  Map<String, Color> kontrolEt(int hizmetId) {
    Map<String, Color> saatDurumlari = {};

    // Belirli bir hizmet için saat dilimlerini al
    List<DateTime> timeSlots = _serviceTimeSlots[hizmetId] ?? [];

    // Hizmet bilgilerini al
    Bilgi? service =
        _selectedServices.firstWhere((s) => s.hizmetId == hizmetId); //firstWhereOrNull((s) => s.hizmetId == hizmetId);

    bool isServiceUnavailable = false;
    if (service.saatlikKapasite == 0 || service.ozelalan == 1) {
      isServiceUnavailable = true;
    }

    for (final timeSlot in timeSlots) {
      String formattedTime = DateFormat('HH:mm').format(timeSlot);
      if (isServiceUnavailable) {
        saatDurumlari[formattedTime] = Colors.red; // Hizmet Kullanılamaz
      } else {
        bool isBookedByUser = _existingAppointments
            .any((r) => r.hizmetid == hizmetId && r.baslangicsaati == formattedTime && r.kullaniciid == currentUserId);

        bool isBookedByOthers = _existingAppointments
            .any((r) => r.hizmetid == hizmetId && r.baslangicsaati == formattedTime && r.kullaniciid != currentUserId);

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

  void selectTimeSlot(DateTime timeSlot, int serviceId, int tesisId) {
    // Check the service's hourly capacity
    Bilgi? service = _selectedServices.firstWhere((s) => s.hizmetId == serviceId);

    // If the service has no capacity or is a special area, the appointment cannot be booked
    if (service.saatlikKapasite == 0 || service.ozelalan == 1) {
      return; // Appointment cannot be booked
    }

    // Process the selected time slot
    String formattedTime = DateFormat('HH:mm').format(timeSlot);
    String formattedDate = DateFormat('dd.MM.yyyy').format(timeSlot);

    // Create the appointment
    Randevu newAppointment = Randevu(
      baslangictarihi: timeSlot,
      bitistarihi: timeSlot.add(Duration(minutes: _servicePeriyots[serviceId]!)),
      formatlibaslangictarihi: formattedDate,
      formatlibitistarihi: formattedDate,
      baslangicsaati: formattedTime,
      bitissaati: DateFormat('HH:mm').format(timeSlot.add(Duration(minutes: _servicePeriyots[serviceId]!))),
      kullaniciid: currentUserId,
      hizmetid: serviceId,
      hizmetad: service.hizmetAd,
      kapasite: service.saatlikKapasite,
    );

    // Add the new appointment to existing appointments
    _existingAppointments.add(newAppointment);

    // Set the selected time slot to green
    slotColors[formattedTime] = Colors.green;

    // Set all other services' time slots on the same date and time to yellow
    _selectedServices.forEach((otherService) {
      if (otherService.hizmetId != serviceId) {
        List<DateTime> otherServiceSlots = _serviceTimeSlots[otherService.hizmetId!] ?? [];
        for (var slot in otherServiceSlots) {
          String otherFormattedTime = DateFormat('HH:mm').format(slot);
          String otherFormattedDate = DateFormat('dd.MM.yyyy').format(slot);
          if (slot.isAtSameMomentAs(timeSlot) && otherFormattedDate == formattedDate) {
            // Set the same time slot for other services to yellow and make them unclickable
            slotColors[otherFormattedTime] = Colors.yellow;
            // Optionally, you can add logic to disable these slots
          }
        }
      }
    });

    // kapasiteyi azaltma
    if (service.saatlikKapasite != null && service.saatlikKapasite! > 0) {
      service.saatlikKapasite = service.saatlikKapasite! - 1; // Decrease capacity
    }

    // Regenerate time slots
    generateTimeSlots(); // Regenerate time slots
    notifyListeners(); // Notify listeners
  }

  void confirmTimeSlot(DateTime timeSlot) {
    if (!confirmedTimeSlots.contains(timeSlot)) {
      confirmedTimeSlots.add(timeSlot);
      String formattedTime = DateFormat('HH:mm').format(timeSlot);
      slotColors[formattedTime] = Colors.green; // Onaylandıktan sonra yeşil yap
      notifyListeners(); // Dinleyicileri bilgilendir
    }
  }
}
