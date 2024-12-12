import 'dart:convert';

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
 late Future<List<RandevuModel>> randevular;

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
    final headers = {
      "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
      "accept-language": "tr-TR,tr;q=0.9,en-US;q=0.8,en;q=0.7",
      "cookie": "PHPSESSID=0ms1fk84dssk9s3mtfmmdsjq24; language=tr",
      "priority": "u=0, i",
      "referer": "https://$apiBaseUrl/randevu/randevularim.php",
      "sec-ch-ua": '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"',
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": '"Windows"',
      "sec-fetch-dest": "document",
      "sec-fetch-mode": "navigate",
      "sec-fetch-site": "same-origin",
      "sec-fetch-user": "?1",
      "upgrade-insecure-requests": "1",
      "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
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

      if (response.statusCode == 200) {
        aktifrandevular = [];
        List<dynamic> jsonData = json.decode(response.body);
        aktifrandevular?.addAll(jsonData.map((item) => RandevuModel.fromJson(item)).toList());

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
        dynamic jsonData = json.decode(response.body);
        kullanicibilgim = Kullanicibilgisi.fromJson(jsonData);
      }

      final response1 = results[1];
      if (response1.statusCode == 200 && response1.body != "false") {
        dynamic jsonData = json.decode(response1.body);
        tesisbilgim = Tesisbilgisi.fromJson(jsonData);
      }

      final response2 = results[2];
      if (response2.statusCode == 200 && response2.body != "false") {
        dynamic jsonData = json.decode(response2.body);
        hizmetbilgim = Hizmetbilgisi.fromJson(jsonData);
      }

      DenemeCard gelen = DenemeCard();
      gelen.kullanicibilgisimodel = kullanicibilgim;
      gelen.hizmetbilgisimodel = hizmetbilgim;
      gelen.tesisbilgisimodel = tesisbilgim;

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
    await fetchRandevuList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<List<RandevuModel>?>(
                future: fetchRandevuList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Hata: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final appointment = data[index];
                        return FutureBuilder<DenemeCard?>(
                            future: deneme(appointment: appointment),
                            builder: (context, snapshot2) {
                              if (snapshot2.connectionState == ConnectionState.waiting) {
                                return Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ));
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
                                return Center(child: Text('Veri bulunamadı'));
                              }
                            });
                      },
                    );
                  } else {
                    return Center(child: Text('Veri bulunamadı'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
    // Randevu kartlarını listele
  }
}
