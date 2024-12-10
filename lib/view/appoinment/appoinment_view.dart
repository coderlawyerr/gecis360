import 'dart:convert' as http;

import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/providers/appoinment/misafir_add_provider.dart';
import 'package:armiyaapp/services/create.dart';

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

class AppointmentView extends StatefulWidget {
  const AppointmentView({super.key});

  @override
  State createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> {
  int? selectedTesisID;
  int? selectedHizmetID;

  @override
  void initState() {
    super.initState();
    // Widget ilk oluşturulduğunda tesisleri çek
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppointmentProvider>(context, listen: false);
      provider.fetchFacilities().catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tesisler alınamadı: $error')),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<AppointmentProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RANDEVU OLUŞTUR',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Tesis Seçimi',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    // 1. Tesis Seçimi Dropdown/// burda apıye ıstek atıyorum teısıs ıcın
                    Container(
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: const BorderRadius.all(Radius.circular(4))),
                      child: DropdownButton<int>(
                        underline: const SizedBox(),
                        hint: const Text(
                          'Tesis Seçiniz',
                          style: TextStyle(color: Colors.grey),
                        ),
                        value: provider.selectedFacilityId, // hayır api ile ilgili değil
                        isExpanded: true,
                        items: provider.facilities.map((facility) {
                          return DropdownMenuItem<int>(
                            value: facility.tesisId,
                            child: Text(facility.tesisAd ?? 'Bilinmeyen Tesis'),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          selectedTesisID = value;
                          provider.setSelectedDate(null);
                          provider.calendarController.selectedDate = null;
                          provider.setSelectedServices([]);

                          if (value != null) {
                            provider.setSelectedFacility(value);
                            try {
                              await provider.fetchServices(value);
                              // Hizmetler yüklendiğinde takvimi yeniden göster

                              provider.resetToCalendar(); // Takvimi sıfırla
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
                    const Text(
                      "Hizmet Seçimi",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    MultiDropdown(
                      fieldDecoration: const FieldDecoration(hintText: "Hizmet Seçiniz!"),
                      items: provider.services.map((service) {
                        return DropdownItem<int>(
                          value: service.hizmetId!,
                          label: service.hizmetAd ?? 'Bilinmeyen Hizmet',
                        );
                      }).toList(),
                      onSelectionChange: (List<int> selectedIds) async {
                        provider.resetToCalendar();
                        provider.setSelectedServices(selectedIds);

                        // Check if selectedIds is not empty before accessing the last element
                        if (selectedIds.isNotEmpty) {
                          selectedHizmetID = selectedIds.last; // Only assign if there are selected IDs
                        } else {
                          // Handle the case where no services are selected, if necessary
                          selectedHizmetID = null; // or some default value
                        }
                      },
                      selectedItemBuilder: (selectedItems) {
                        // Seçilen hizmetlerin nasıl görüneceğini burada özelleştirebilirsiniz
                        return Wrap(spacing: 8.0, children: [
                          Chip(
                            padding: EdgeInsets.zero,
                            label: Text(selectedItems.label),
                            onDeleted: () {
                              // Chip silindiğinde hizmeti seçili listeden çıkar
                              final id = selectedItems.value;
                              selectedHizmetID = id;
                              final updatedIds = List<int>.from(provider.selectedServiceIds);
                              updatedIds.remove(id);
                              provider.resetToCalendar();
                              // provider.setSelectedServices(updatedIds);
                            },
                          )
                        ]);
                      },
                    ),

                    const SizedBox(height: 20),
                    // Takvim
                    Visibility(
                      visible: provider.showCalendar,
                      child: Column(
                        children: [
                          // Takvim Kontrolleri
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  provider.calendarController.backward!();
                                },
                                icon: const Icon(Icons.arrow_back_ios_new),
                              ),
                              IconButton(
                                onPressed: () {
                                  provider.calendarController.forward!();
                                },
                                icon: const Icon(Icons.arrow_forward_ios_sharp),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  provider.calendarController.displayDate = DateTime.now();
                                },
                                child: const Text('Bugün'),
                              ),
                            ],
                          ),
                          // Takvim
                          provider.buildCalendar(context),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Saat Dilimleri
                    Visibility(
                      visible: provider.showTimeSlots && provider.serviceTimeSlots.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Randevu Saati Seçimi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          const Text(
                            'Mavi : Randevu eklenebilir',
                            style: TextStyle(color: Colors.blue),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          const Text(
                            'Kırmızı : Kapasite dolu',
                            style: TextStyle(color: Colors.red),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          const Text(
                            'Yeşil: Kayıtlı randevunuz',
                            style: TextStyle(color: Colors.green),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          const Text(
                            'Sarı: Aynı saatte randevunuz var',
                            style: TextStyle(color: Colors.yellow),
                          ),
                          const SizedBox(height: 10),
                          // Takvime Dön Butonu
                          Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                              onPressed: () {
                                provider.backToCalendar(); // Takvimi geri getir
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5664D9), // Butonun arka plan rengi
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Takvime Dön',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                          // Saat Dilimlerini Listele (Her Hizmet için)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.selectedServices.length,
                            itemBuilder: (context, serviceIndex) {
                              final service = provider.selectedServices[serviceIndex];
                              final serviceId = service.hizmetId!;
                              final serviceSlots = provider.serviceTimeSlots[serviceId] ?? []; // saat aralıkları apıden geliyor

                              // Renk haritasını al
                              final colorMap = provider.kontrolEt(serviceId);

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Hizmet Adı ve Kapasite Bilgisi
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
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
                                            final periyot = provider.servicePeriyots[serviceId]!;
                                            final bitisSaati = timeSlot.add(Duration(minutes: periyot));
                                            final formattedStartTime = DateFormat('HH:mm').format(timeSlot);
                                            final formattedEndTime = DateFormat('HH:mm').format(bitisSaati);

                                            // Onaylanan saat kontrolü
                                            bool isDisabled = provider.kontrolEt(serviceId).values.any((c) => c.value == Colors.green.value) &&
                                                provider.slotColors[formattedStartTime]?.value !=
                                                    Colors.green.value; // Eğer başka bir saat onaylandıysa, diğer saatleri devre dışı bırak
                                            // Geçmiş saat dilimlerini kontrol et
                                            bool isPast = timeSlot.isBefore(DateTime.now());

                                            // Renk haritasına göre rengi belirle
                                            // Renk haritasına göre rengi belirle
                                            var slotColor = provider.slotColors[formattedStartTime] ?? Colors.blue.shade100;
                                            if (isDisabled) slotColor = Colors.grey;
                                            print('Seçili mi?? $isDisabled');

                                            return Opacity(
                                              opacity: isPast ? 0.5 : 1.0,
                                              child: GestureDetector(
                                                ///////////////
                                                onTap: isPast || slotColor == Colors.green || slotColor == Colors.red || slotColor == Colors.grey
                                                    ? null // Geçmiş saatler, kullanıcı tarafından alınmış ve başkaları tarafından alınmış saatler için tıklamayı devre dışı bırak
                                                    : () {
                                                        //
                                                        provider.selectTimeSlot(timeSlot, serviceId);
                                                        if (provider.serviceTimeSlots.containsValue([timeSlot])) {
                                                          return;
                                                        }

                                                        // Saat dilimi seçimini işleme
                                                        provider.selectTimeSlot(timeSlot, serviceId);

                                                        ////////////////////////////////////////////////dıalog acccc
                                                        showAppointmentDialog(context, isDisabled, timeSlot, service, serviceIndex, slotIndex);
                                                        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                      },
                                                child: Chip(
                                                  label: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        '$formattedStartTime - $formattedEndTime',
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      // Ekstra göstergeler eklemek isterseniz burada yapabilirsiniz
                                                    ],
                                                  ),
                                                  backgroundColor: slotColor,
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

  void showAppointmentDialog(BuildContext context, bool isDisabled, DateTime selectedTime, Bilgi service, int serviceIndex, int slotIndex) async {
    final provider = Provider.of<AppointmentProvider>(context, listen: false);
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
      isScrollControlled: true, // Bu, modalın tam ekran olmasını sağlar.
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
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Row(
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
                          const SizedBox(height: 30),
                          // Kalan Randevu Kutusu
                          Container(
                            padding: const EdgeInsets.all(3),
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
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (isMisafirKabul && (selectedGroup == null))
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                builder: (context) {
                                  return FractionallySizedBox(
                                    heightFactor: 0.90, // Yüksekliğin 4/3 oranında açılması için
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom,
                                      ),
                                      child: const MisafirAdd(), // MisafirAdd sayfası burada modal olarak açılır
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5664D9),
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Misafir Ekle',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                          ),
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
                                            heightFactor: 0.90,
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
                                    authorization: 'cm9vdEBnZWNpczM2MC5jb206MTIzNDEyMzQ=', // Authorization bilgisi
                                    phpSessionId: '0ms1fk84dssk9s3mtfmmdsjq24', // PHPSESSID
                                    kullaniciId: user?.iD?.toString() ?? "", // Kullanıcı ID
                                    token: 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as', // Token
                                    hizmetId: selectedHizmetID.toString(), //"25" // Hizmet ID
                                    tesisId: selectedTesisID.toString(), // '1', // Tesis ID
                                    baslangicTarihi: selectedTime.toString().replaceAll("T", " "), // Başlangıç tarihi
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
                                  });

                                  // Misafir listesini temizle
                                  context.read<MisafirAddProvider>().clearMisafirList();

                                  if (res == "SUCCESS") {
                                    // Randevu onaylandı
                                    provider.decreaseCapacity(selectedHizmetID!); // Decrease the capacity
                                    setState(() {
                                      isConfirmed = true; // Update confirmation state
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
