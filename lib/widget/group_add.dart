import 'dart:convert';
import 'package:armiyaapp/providers/appoinment/appoinment_provider.dart';
import 'package:armiyaapp/view/appoinment/appointment_calender/appointment_calender_service.dart';
import 'package:armiyaapp/view/appoinment/appointment_calender/model/group_details.model.dart';
import 'package:flutter/material.dart';

class GroupAdd extends StatefulWidget {
  const GroupAdd({Key? key, required this.selectedServiceIds}) : super(key: key);

  final List<int> selectedServiceIds;

  @override
  _GroupAddState createState() => _GroupAddState();
}

class _GroupAddState extends State<GroupAdd> {
  List<Uyegruplari> uyegruplari = [];
  bool isLoading = true;
  String? error;
  Uyegruplari? selectedGroup;

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final response = await AppointmentService().fetchGroupDetails(
        selectedFacilityId: AppointmentProvider().selectedFacilityId ?? 0,
        selectedServiceIds: widget.selectedServiceIds,
      );

      if (response != null && response.uyegruplari != null) {
        setState(() {
          uyegruplari = response.uyegruplari!.whereType<Uyegruplari>().where((group) => group != null).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Veri alınamadı';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Bir hata oluştu: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Grup Ekle'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchGroups,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    if (uyegruplari.isEmpty) {
      return const Center(child: Text('Henüz grup eklenmedi.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: uyegruplari.length,
      itemBuilder: (context, index) {
        return _buildGroupCard(uyegruplari[index]);
      },
    );
  }

  Widget _buildGroupCard(Uyegruplari group) {
    // `uyeler` JSON formatındaki stringi parse et
    List<dynamic> uyelerList = [];
    if (group.uyeler != null) {
      try {
        uyelerList = json.decode(group.uyeler!);
      } catch (e) {
        debugPrint('Uyeler JSON parse hatası: $e');
      }
    }

    // `grup_yetkili` JSON formatındaki stringi parse et
    String yetkiliAdi = 'Bilinmiyor';
    if (group.grupYetkili != null) {
      try {
        List<dynamic> yetkiliList = json.decode(group.grupYetkili!);
        if (yetkiliList.isNotEmpty && yetkiliList[0]['yetkili_adi'] != null) {
          yetkiliAdi = yetkiliList[0]['yetkili_adi'];
        }
      } catch (e) {
        debugPrint('Grup Yetkili JSON parse hatası: $e');
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grup Adı - Mavi Arkaplan
          Container(
            width: double.infinity,
            color: Colors.blue.shade100,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              children: [
                // Radio ile seçim
                Radio<Uyegruplari>(
                  value: group,
                  groupValue: selectedGroup,
                  onChanged: (Uyegruplari? value) {
                    setState(() {
                      selectedGroup = value;
                    });
                    Navigator.pop(context, value);
                  },
                ),
                Expanded(
                  child: Text(
                    group.grupAdi ?? 'Grup Adı Yok',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${uyelerList.length} kullanıcı',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Yetkili Gösterimi
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 8, color: Colors.blue),
                const SizedBox(width: 5),
                Text(
                  'Yetkili: $yetkiliAdi',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Üyeler Listesi
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Üyeler:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 8,
                  runSpacing: 5,
                  children: uyelerList.map((uye) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.circle, size: 6, color: Colors.black),
                        const SizedBox(width: 5),
                        Text(
                          uye['uye_adi'] ?? 'Bilinmeyen Üye',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
