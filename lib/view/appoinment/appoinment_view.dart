import 'dart:convert' as http;
import 'dart:developer';

import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/providers/appoinment/misafir_add_provider.dart';
import 'package:armiyaapp/services/create.dart';
import 'package:armiyaapp/view/appoinment/appointment_calender/model/randevu_model.dart';

import 'package:armiyaapp/widget/group_add.dart';
import 'package:armiyaapp/widget/misafir_add.dart';
import 'package:http/http.dart' as http;
import 'package:armiyaapp/const/const.dart';
import 'package:armiyaapp/model/new_model/newmodel.dart';
import 'package:armiyaapp/providers/appoinment/appoinment_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'appointment_calender/model/group_details.model.dart' as GroupDetailsModel;

const double _ekleSheetHeightFactor = 0.50;

class AppointmentView extends StatefulWidget {
  const AppointmentView({super.key, required this.onConfirm});
  final Function() onConfirm;
  @override
  State createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> {
  late AppointmentProvider appointmentProvider;

  int? selectedTesisID;
  int? selectedHizmetID;

  /// If user has appointment in same day it returns true
  bool alreadyBooked(List<RandevuModel> allAppointments, DateTime selectedDate) => allAppointments.any((element) {
        final elementStartTime = DateTime.tryParse(element.baslangicTarihi!);
        return selectedDate.month == elementStartTime!.month && selectedDate.day == elementStartTime.day && selectedDate.year == elementStartTime.year;
      });

  @override
  void initState() {
    super.initState();
    // Widget ilk oluşturulduğunda tesisleri çek
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
      appointmentProvider.fetchFacilities().catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tesisler alınamadı: $error')),
        );
      });
    });
  }

  @override
  void dispose() {
    appointmentProvider.clean();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Consumer<AppointmentProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            appointmentProvider = provider;
            print(appointmentProvider.allAppointments);
            print(appointmentProvider.allAppointments.length);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RANDEVU OLUŞTUR',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal, color: Colors.grey),
                    ),
                    const SizedBox(height: 45),
                    const Text('Tesis Seçimi', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 10),
                    // 1. Tesis Seçimi Dropdown/// burda apıye ıstek atıyorum teısıs ıcın
                    Container(
                      margin: const EdgeInsets.all(1),
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                      ),
                      child: DropdownButton<int>(
                        underline: const SizedBox(),
                        hint: Padding(
                          padding: const EdgeInsets.only(left: 8.0), // Yazıyı sağa kaydırmak için padding eklendi
                          child: const Text(
                            'Tesis Seçiniz!',
                          ),
                        ),
                        value: appointmentProvider.selectedFacilityId,
                        isExpanded: true,
                        items: appointmentProvider.facilities
                            .map((facility) => DropdownMenuItem<int>(
                                  value: facility.tesisId,
                                  child: Text(facility.tesisAd ?? 'Bilinmeyen Tesis'),
                                ))
                            .toList(),
                        onChanged: (value) async {
                          selectedTesisID = value;
                          appointmentProvider.setSelectedDate(null);
                          appointmentProvider.calendarController.selectedDate = null;
                          appointmentProvider.setSelectedServices([]);

                          if (value != null) {
                            appointmentProvider.setSelectedFacility(value);
                            try {
                              await appointmentProvider.fetchServices(value);
                              appointmentProvider.resetToCalendar(); // Takvimi sıfırla
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Hizmetleri alırken hata oluştu: $e',
                                    style: TextStyle(color: primaryColor),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                    // 2. Hizmet Seçimi (MultiDropdown)
                    const Text("Hizmet Seçimi", style: TextStyle(fontSize: 16, color: Colors.grey)),
                    SizedBox(
                      height: 15,
                    ),
                    MultiDropdown(
                      fieldDecoration: const FieldDecoration(
                        hintText: "Hizmet Seçiniz!",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)), // Kenar ovali azaltıldı
                        ),
                      ),
                      items: appointmentProvider.services
                          .map((service) => DropdownItem<int>(
                                value: service.hizmetId!,
                                label: service.hizmetAd ?? 'Bilinmeyen Hizmet',
                              ))
                          .toList(),
                      onSelectionChange: (List<int> selectedIds) async {
                        appointmentProvider.resetToCalendar();
                        appointmentProvider.setSelectedServices(selectedIds);

                        if (selectedIds.isNotEmpty) {
                          selectedHizmetID = selectedIds.last;
                        } else {
                          selectedHizmetID = null;
                        }
                      },
                      selectedItemBuilder: (selectedItems) {
                        return Wrap(
                          spacing: 8.0,
                          children: [
                            Chip(
                              padding: EdgeInsets.zero,
                              label: Text(selectedItems.label),
                              onDeleted: () {
                                final id = selectedItems.value;
                                selectedHizmetID = id;
                                final updatedIds = List<int>.from(appointmentProvider.selectedServiceIds);
                                updatedIds.remove(id);
                                appointmentProvider.resetToCalendar();
                              },
                            ),
                          ],
                        );
                      },
                      dropdownDecoration: DropdownDecoration(
                        backgroundColor: Colors.white,
                        borderRadius: BorderRadius.circular(4), // Oval kenarları azaltıldı
                      ),
                    ),

                    const SizedBox(height: 20),
                    // Takvim
                    if (provider.showCalendar)
                      Column(
                        children: [
                          // Takvim Kontrolleri
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => appointmentProvider.calendarController.backward!(),
                                icon: const Icon(Icons.arrow_back_ios_new),
                              ),
                              IconButton(
                                onPressed: () => appointmentProvider.calendarController.forward!(),
                                icon: const Icon(Icons.arrow_forward_ios_sharp),
                              ),
                              ElevatedButton(
                                onPressed: () => appointmentProvider.calendarController.displayDate = DateTime.now(),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // Yuvarlaklığı azaltmak için düşük bir değer ver
                                  ),
                                  backgroundColor: Colors.white, // Butonun arka plan rengi
                                ),
                                child: const Text(
                                  'Bugün',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 75, 75, 75), // Yazı rengi
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Takvim
                          appointmentProvider.buildCalendar(context)
                        ],
                      ),
                    const SizedBox(height: 20),

                    // Saat Dilimleri
                    Visibility(
                      visible: appointmentProvider.showTimeSlots && appointmentProvider.serviceTimeSlots.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Randevu Saati Seçimi',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text('Mavi : Randevu eklenebilir', style: TextStyle(color: Colors.blue)),
                          const SizedBox(height: 2),
                          const Text('Kırmızı : Kapasite dolu', style: TextStyle(color: Colors.red)),
                          const SizedBox(height: 2),
                          const Text('Yeşil: Kayıtlı randevunuz', style: TextStyle(color: Colors.green)),
                          const SizedBox(height: 2),
                          const Text('Sarı: Aynı saatte randevunuz var', style: TextStyle(color: Colors.yellow)),
                          const SizedBox(height: 10),
                          // Takvime Dön Butonu
                          Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                              onPressed: () => appointmentProvider.backToCalendar(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5664D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Takvime Dön', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          // Saat Dilimlerini Listele (Her Hizmet için)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: appointmentProvider.selectedServices.length,
                            itemBuilder: (context, serviceIndex) {
                              final service = appointmentProvider.selectedServices[serviceIndex];
                              final serviceId = service.hizmetId!;
                              final serviceSlots = appointmentProvider.serviceTimeSlots[serviceId] ?? [];
                              // saat aralıkları apıden geliyor

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Hizmet Adı ve Kapasite Bilgisi
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Text(service.hizmetAd ?? ""),
                                  ),
                                  // Saat Dilimleri
                                  serviceSlots.isNotEmpty
                                      ? GridView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.all(8.0),
                                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 150.0, // Adjusted width
                                            mainAxisSpacing: 8.0,
                                            crossAxisSpacing: 8.0,
                                            childAspectRatio: 3 / 1,
                                          ),
                                          itemCount: serviceSlots.length,
                                          itemBuilder: (context, slotIndex) {
                                            final timeSlot = serviceSlots[slotIndex];
                                            final periyot = appointmentProvider.servicePeriyots[serviceId]!;
                                            final bitisSaati = timeSlot.add(Duration(minutes: periyot));
                                            final formattedStartTime = DateFormat('HH:mm').format(timeSlot);
                                            final formattedEndTime = DateFormat('HH:mm').format(bitisSaati);
                                            final bool isPast = timeSlot.isBefore(DateTime.now());

                                            bool isConflictedWithOtherService = appointmentProvider.allAppointments.any((element) {
                                              final elementStartTime = DateTime.tryParse(element.baslangicTarihi!);
                                              final elementEndTime = DateTime.tryParse(element.bitisTarihi!);
                                              return element.tesisId != selectedTesisID &&
                                                  (timeSlot.isBefore(elementEndTime!) && bitisSaati.isAfter(elementStartTime!));
                                            });

                                            // bool alreadyBooked = false;

                                            bool alreadyBooked = appointmentProvider.allAppointments.any((element) {
                                              final elementStartTime = DateTime.tryParse(element.baslangicTarihi!);
                                              final elementEndTime = DateTime.tryParse(element.bitisTarihi!);
                                              return element.tesisId == selectedTesisID &&
                                                  (timeSlot.isBefore(elementEndTime!) && bitisSaati.isAfter(elementStartTime!));
                                            });

                                            Color chipColor;
                                            if (isPast) {
                                              // Geçmiş saatler
                                              chipColor = Colors.grey;
                                            } else if (isConflictedWithOtherService) {
                                              //Farkli tesiste ayni saatte randevu varsa
                                              chipColor = Colors.yellow;
                                            } else if (alreadyBooked) {
                                              //Ayni tesiste ayni saatte randevu varsa
                                              chipColor = Colors.green;
                                            } else {
                                              //Varsilan Renk
                                              chipColor = Colors.blue;
                                            }

                                            bool isDisabled = appointmentProvider.kontrolEt(serviceId).values.any((c) => c.value == Colors.green.value) &&
                                                appointmentProvider.slotColors[formattedStartTime]?.value != Colors.green.value;

                                            print('Seçili mi?? $isDisabled');

                                            return Opacity(
                                              opacity: isPast ? 0.5 : 1.0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (this.alreadyBooked(appointmentProvider.allAppointments,
                                                      appointmentProvider.calendarController.selectedDate ?? DateTime.now())) {
                                                    return;
                                                  }

                                                  if (isPast ||
                                                      chipColor == Colors.yellow ||
                                                      chipColor == Colors.green ||
                                                      chipColor == Colors.red ||
                                                      chipColor == Colors.grey) return;
                                                  if (appointmentProvider.serviceTimeSlots.containsValue([timeSlot])) {
                                                    return;
                                                  }
                                                  // Saat dilimi seçimini işleme

                                                  ////////////////////////////////////////////////dıalog acccc
                                                  showAppointmentDialog(
                                                    context,
                                                    isDisabled,
                                                    timeSlot,
                                                    service,
                                                    serviceIndex,
                                                    slotIndex,
                                                    timeSlot,
                                                    serviceId,
                                                    appointmentProvider,
                                                    widget.onConfirm,
                                                  );
                                                  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                },
                                                child: Chip(
                                                  label: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        '$formattedStartTime - $formattedEndTime',
                                                        style: const TextStyle(color: Colors.black, fontSize: 12),
                                                      ),
                                                      // Ekstra göstergeler eklemek isterseniz burada yapabilirsiniz
                                                    ],
                                                  ),
                                                  backgroundColor: chipColor,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : const Text(
                                          'Bu hizmet için uygun saat dilimi bulunmamaktadır.',
                                          style: TextStyle(color: Colors.red),
                                        ),

                                  const SizedBox(height: 20),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showAppointmentDialog(
    BuildContext context,
    bool isDisabled,
    DateTime selectedTime,
    Bilgi service,
    int serviceIndex,
    int slotIndex,
    DateTime timeSlot,
    int serviceId,
    AppointmentProvider provider,
    Function() onConfirm,
  ) async {
    bool isConfirmed = false; // Randevunun onaylandığını izlemek için
    GroupDetailsModel.Uyegruplari? selectedGroup; // Seçilen grup ID'sini saklamak için

    // Seçilen tesis ve hizmet bilgilerini al
    String selectedFacility = provider.selectedFacilityId != null
        ? provider.facilities.firstWhere((f) => f.tesisId == provider.selectedFacilityId).tesisAd ?? 'Bilinmeyen Tesis'
        : 'Tesis Seçilmedi';

    String selectedService = provider.selectedServiceIds.isNotEmpty ? provider.selectedServices.map((s) => s.hizmetAd).join(', ') : 'Hizmet Seçilmedi';

    // Seçilen zaman dilimini belirleyin
    final periyot = provider.servicePeriyots[service.hizmetId]!; // Hizmetin periyodunu al
    final endTime = selectedTime.add(Duration(minutes: periyot)); // Bitiş zamanını hesapla

    // Tarih ve saat formatlama
    String formattedStartTime = DateFormat('dd.MM.yyyy - HH:mm').format(selectedTime);
    String formattedEndTime = DateFormat('dd.MM.yyyy - HH:mm').format(endTime);

    // Misafir kabul durumu kontrolü
    bool isMisafirKabul = service.misafirKabul == 1;
    bool isGroup = service.grupRandevusu == 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Bu, modalın tam ekran olmasını sağlar.
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Randevu Onayı',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        // Mevcut Randevu Kutusu
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF5664D9)),
                          ),
                          child: Text(
                            'Mevcut Randevu: ${provider.existingAppointments.where((r) => r.hizmetid == service.hizmetId).length}', // Current appointments count
                            style: const TextStyle(fontSize: 14, color: Color(0xFF5664D9)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Kalan Randevu Kutusu
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF5664D9)),
                          ),
                          child: Text(
                            'Kalan Randevu: ${service.saatlikKapasite ?? 'Bilinmiyor'}',
                            style: const TextStyle(
                              color: Color(0xFF5664D9),
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      color: isConfirmed ? Colors.green.shade100 : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Seçilen Tesis: $selectedFacility'),
                          const SizedBox(height: 5),
                          Text('Seçilen Hizmet: $selectedService'),
                          const SizedBox(height: 5),
                          Text('Başlangıç Zaman: $formattedStartTime'), // Başlangıç ve bitiş saatini göster
                          const SizedBox(height: 5),
                          Text('Bitiş Zaman: $formattedEndTime'), // Başlangıç ve bitiş saatini göster
                        ],
                      ),
                    ),
                    if (selectedGroup != null) Text('Seçilen Grup: ${selectedGroup?.grupAdi}'),
                    if (selectedGroup != null) const SizedBox(height: 30),
                    Consumer<MisafirAddProvider>(
                      builder: (context, value, error) {
                        return Visibility(
                          visible: value.misafirList.isNotEmpty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Misafirler'),
                              const Divider(),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.height * 0.5, // Maksimum yüksekliği belirler
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(), // Render hatalarını önler
                                  itemCount: value.misafirList.length,
                                  itemBuilder: (context, index) {
                                    final misafir = value.misafirList[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Text('Ad Soyad: ${misafir['adSoyad'] ?? 'Bilinmiyor'}'),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isMisafirKabul && (selectedGroup == null)) SizedBox(width: 2),

                        ///soldan bosluk
                        ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: _ekleSheetHeightFactor,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).viewInsets.bottom,
                                    ),
                                    child: MisafirAdd(), // MisafirAdd sayfası burada modal olarak açılır
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5664D9),
                            padding: EdgeInsets.symmetric(horizontal: 0.1, vertical: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          // Butonlar arasında boşluk
                          child: Text(
                            'Misafir Ekle',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        if (isGroup && selectedGroup == null)
                          Consumer<MisafirAddProvider>(
                            builder: (context, misafirProvider, child) => ElevatedButton(
                              onPressed: misafirProvider.misafirList.isNotEmpty
                                  ? () {
                                      showTopSnackBar(
                                        context,
                                        'Şu an misafir seçilidir. Önce misafir listesini temizlemelisiniz.',
                                      );
                                    }
                                  : () async {
                                      final result = await showModalBottomSheet<GroupDetailsModel.Uyegruplari>(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                        ),
                                        builder: (context) {
                                          return FractionallySizedBox(
                                            heightFactor: _ekleSheetHeightFactor,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context).viewInsets.bottom,
                                              ),
                                              child: GroupAdd(
                                                selectedServiceIds: provider.selectedServiceIds,
                                              ),
                                            ),
                                          );
                                        },
                                      );

                                      if (result != null) {
                                        setState(() {
                                          selectedGroup = result;
                                        });
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: misafirProvider.misafirList.isNotEmpty ? Colors.grey : const Color(0xFF5664D9),
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Grup Ekle',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: isConfirmed == true
                              ? null
                              : () async {
                                  final user = await SharedDataService().getLoginData();
                                  // Randevu bilgilerini gönder
                                  final res = await createAppointment(
                                    authorization: 'cm9vdEBnZWNpczM2MC5jb206MTIzNDEyMzQ=',
                                    // Authorization bilgisi
                                    phpSessionId: '0ms1fk84dssk9s3mtfmmdsjq24',
                                    // PHPSESSID
                                    kullaniciId: user?.iD?.toString() ?? "",
                                    // Kullanıcı ID
                                    token: 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
                                    // Token
                                    hizmetId: selectedHizmetID.toString(),
                                    //"25" // Hizmet ID
                                    tesisId: selectedTesisID.toString(),
                                    // '1', // Tesis ID
                                    baslangicTarihi: selectedTime.toString().replaceAll("T", " "),
                                    // Başlangıç tarihi
                                    bitisTarihi: endTime.toString().replaceAll("T", " "),
                                  );

                                  // Randevu bilgilerini güncelle
                                  if (context.read<MisafirAddProvider>().misafirList.isEmpty) {
                                    provider.updateSlotColor(serviceIndex, slotIndex, Colors.green);
                                    // Kalan randevu sayısını azalt
                                    if (service.saatlikKapasite != null && service.saatlikKapasite! > 0) {
                                      setState(() {
                                        service.saatlikKapasite = service.saatlikKapasite! - 1; // Kalan randevu sayısını bir azalt
                                      });
                                    }

                                    // Eğer kalan randevu sayısı sıfırsa, slot rengini kırmızı yap
                                    if (service.saatlikKapasite == 0) {
                                      provider.updateSlotColor(serviceIndex, slotIndex, Colors.red);
                                    }
                                  } else {
                                    provider.updateSlotColor(serviceIndex, slotIndex, Colors.yellow);
                                  }

                                  // Randevu onaylandı
                                  setState(() {
                                    isConfirmed = true;
                                    Navigator.pop(context);
                                    onConfirm();
                                  });

                                  // Misafir listesini temizle
                                  context.read<MisafirAddProvider>().clearMisafirList();

                                  if (res == "SUCCESS") {
                                    // Randevu onaylandı
                                    provider.decreaseCapacity(selectedHizmetID!); // Decrease the capacity
                                    setState(() {
                                      isConfirmed = true; // Update confirmation state
                                      provider.selectTimeSlot(timeSlot, serviceId, selectedTesisID ?? 0);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Zaten bir randevunuz mevcut!")));
                                  }
                                },
                          child: Text(
                            isConfirmed == true ? 'Onaylandı' : 'Onayla',
                            style: const TextStyle(color: Color(0xFF5664D9)),
                          ),
                        ),
                        TextButton(
                          onPressed: isConfirmed == true
                              ? () {
                                  Navigator.of(context).pop();
                                }
                              : () {
                                  Navigator.of(context).pop();

                                  // Seçilen randevu gününü iptal eder
                                  setState(() {
                                    isConfirmed = false;
                                    isDisabled = false;
                                    provider.services.clear();
                                  });
                                },
                          child: Text(
                            isConfirmed == true ? 'Geri' : 'İptal',
                            style: const TextStyle(color: Color(0xFF5664D9)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showTopSnackBar(BuildContext context, String message, {Color backgroundColor = Colors.red}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Status bar yüksekliği + boşluk
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.close, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
