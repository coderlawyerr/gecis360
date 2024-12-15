import 'dart:convert';
import 'dart:developer';

import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/model/cancelappointment.dart';
import 'package:armiyaapp/model/deneme.dart';
import 'package:armiyaapp/model/hizmet_bilgisi.dart';
import 'package:armiyaapp/model/kullanici_bilgisi.dart';
import 'package:armiyaapp/model/tesisbilgisi.dart';
import 'package:armiyaapp/model/usermodel.dart';
import 'package:armiyaapp/providers/iptal_randevu_provider.dart';
import 'package:armiyaapp/services/cancaled_appointment.dart';
import 'package:armiyaapp/utils/constants.dart';
import 'package:armiyaapp/view/appoinment/appointment_calender/model/randevu_model.dart';
import 'package:armiyaapp/view/canceled_appointment.dart';
import 'package:armiyaapp/view/my_canceledappointment.dart';
import 'package:armiyaapp/widget/uyari_widget.dart';
import 'package:flutter/material.dart';

import 'package:armiyaapp/widget/appointmentcard.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../providers/appoinment/appoinment_provider.dart';

class ActiveAppointment extends StatefulWidget {
  const ActiveAppointment({super.key});

  @override
  State<ActiveAppointment> createState() => _ActiveAppointmentState();
}

class _ActiveAppointmentState extends State<ActiveAppointment> {
  UserModel? myusermodel;
  AppointmentProvider provider = AppointmentProvider();

  late final Future<List<DenemeCard>?> cardim;
  List<RandevuModel>? aktifrandevular;
  Kullanicibilgisi? kullanicibilgim;
  Hizmetbilgisi? hizmetbilgim;
  Tesisbilgisi? tesisbilgim;
  Map<int, DenemeCard> denemecardim = {};
  List<RandevuModel> canceledAppointments = []; // İptal edilen randevular için liste

  getUser() async {
    myusermodel = await SharedDataService().getLoginData();
  }

  Future<void> fetchData() async {
    final url = "https://$apiBaseUrl/randevu/randevularim.php";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print("Response body: ${response.body}");
      } else {
        print("Failed to load data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  /////
  Future<List<RandevuModel>?> fetchRandevuList() async {
    await getUser();
    final url = 'https://$apiBaseUrl/api/randevu/olustur/index.php';
    const headers = {
      'Authorization': 'Basic cm9vdEBnZWNpczM2MC5jb206MTIzNDEyMzQ=',
      'PHPSESSID': '0ms1fk84dssk9s3mtfmmdsjq24',
    };
    final body = {'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as', 'aktifrandevular': '1', 'kullanici_id': myusermodel?.iD?.toString() ?? ""};

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      log(response.body);
      if (response.statusCode == 200) {
        aktifrandevular = [];
        List<dynamic> jsonData = json.decode(response.body);
        aktifrandevular?.addAll(jsonData.map((item) => RandevuModel.fromJson(item)).toList());
        context.read<AppointmentProvider>().allAppointments.addAll(aktifrandevular ?? []);
        return aktifrandevular;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('İstek sırasında hata oluştu: $e');
    }
  }

  Future<DenemeCard> deneme({required RandevuModel appointment}) async {
    await getUser();
    final url = 'https://$apiBaseUrl/api/genel/index.php';
    const headers = {
      'Authorization': 'Basic cm9vdEBnZWNpczM2MC5jb206MTIzNDEyMzQ=',
      'PHPSESSID': '0ms1fk84dssk9s3mtfmmdsjq24',
    };
    final body = {'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as', 'kullanicibilgisi': appointment.kullaniciId?.toString()};

    final body1 = {'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as', 'tesisbilgisi': appointment.tesisId?.toString()};
    final body2 = {'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as', 'hizmetbilgisi': appointment.hizmetId?.toString()};

    try {
      if (denemecardim[appointment.randevuId!] != null) return denemecardim[appointment.randevuId!]!;

      var results = await Future.wait([
        http.post(Uri.parse(url), headers: headers, body: body),
        http.post(Uri.parse(url), headers: headers, body: body1),
        http.post(Uri.parse(url), headers: headers, body: body2),
      ]);

      final response = results[0];
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        kullanicibilgim = Kullanicibilgisi.fromJson(jsonData);
      }

      final response1 = results[1];
      if (response1.statusCode == 200 && response1.body != "false") {
        final decodedBody = utf8.decode(response1.bodyBytes);

        final jsonData = json.decode(decodedBody);
        tesisbilgim = Tesisbilgisi.fromJson(jsonData);
      }

      final response2 = results[2];
      if (response2.statusCode == 200 && response2.body != "false") {
        final jsonData = json.decode(response2.body);
        hizmetbilgim = Hizmetbilgisi.fromJson(jsonData);
      }

      DenemeCard gelen = DenemeCard();

      gelen.kullanicibilgisimodel = kullanicibilgim;
      gelen.hizmetbilgisimodel = hizmetbilgim;
      gelen.tesisbilgisimodel = tesisbilgim;

      gelen.hizmetbilgisimodel?.aktifsaatBaslangic = appointment.baslangicTarihi;

      denemecardim[appointment.randevuId!] = gelen;
      return gelen;
    } catch (e) {
      throw Exception('İstek sırasında hata oluştu: $e');
    }
  }

  @override
  void initState() {
    init();
    super.initState();
    init();
  }

  init() async {
    // await fetchRandevuList();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<List<RandevuModel>?>(
              future: fetchRandevuList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return data.isEmpty
                      ? AktifAppointmnetCard()
                      : Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final appointment = data[index];
                              return FutureBuilder<DenemeCard?>(
                                  future: deneme(appointment: appointment),
                                  builder: (context, snapshot2) {
                                    if (snapshot2.connectionState == ConnectionState.waiting) {
                                      return const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else if (snapshot2.hasError) {
                                      return Center(child: Text('Hata: ${snapshot2.error}'));
                                    } else if (snapshot2.hasData) {
                                      final data2 = snapshot2.data!;
                                      final bet = data2;

                                      return AppointmentCard(
                                        buttonText: "Randevuyu iptal et!",
                                        title: bet.tesisbilgisimodel?.tesisAd ?? "",
                                        subtitle: bet.hizmetbilgisimodel?.hizmetAd ?? "",
                                        date: appointment.baslangicTarihi?.split(" ").first.toString() ?? "boş",
                                        startTime: bet.hizmetbilgisimodel?.aktifsaatBaslangic ?? "",
                                        endTime: bet.hizmetbilgisimodel?.aktifsaatBitis ?? "",
                                        onButtonPressed: () async {
                                          bool control = await CancaledAppointmentService.CancaledAppointment(aktifrandevular![index].randevuId!);
                                          print("control :$control");
                                          print("merhab");
                                          if (control) {
                                            // İptal edilen randevuyu provider'a ekle
                                            var iptalRandevuProvider = Provider.of<IptalRandevuProvider>(context, listen: false);
                                            var appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
                                            appointmentProvider.removeAppointment(appointment.randevuId!);
                                            iptalRandevuProvider.iptalEdilenRandevuEkle(Mycancelappointment(
                                              randevuId: aktifrandevular![index].randevuId,
                                              hizmetId: aktifrandevular![index].hizmetId,
                                              // Diğer alanlar...
                                            ));
                                          }
                                          setState(() {});
                                        },
                                      );
                                    } else {
                                      return const Center(child: Text('Veri bulunamadı'));
                                    }
                                  });
                            },
                          ),
                        );
                } else {
                  return const Center(child: Text('Veri bulunamadı'));
                }
              },
            ),
          ],
        ),
      ),
    );
    // Randevu kartlarını listele
  }
}
