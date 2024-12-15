/////ıptal   randevualr
import 'dart:convert';

import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/model/cancelappointment.dart';
import 'package:armiyaapp/model/deneme.dart';
import 'package:armiyaapp/model/hizmet_bilgisi.dart';
import 'package:armiyaapp/model/kullanici_bilgisi.dart';
import 'package:armiyaapp/model/tesisbilgisi.dart';
import 'package:armiyaapp/model/usermodel.dart';
import 'package:armiyaapp/utils/constants.dart';
import 'package:armiyaapp/widget/appointmentcard.dart';
import 'package:armiyaapp/widget/uyari_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CanceledAppointment extends StatefulWidget {
  const CanceledAppointment({super.key});

  @override
  State<CanceledAppointment> createState() => _CanceledAppointment();
}

class _CanceledAppointment extends State<CanceledAppointment> {
  UserModel? myusermodel;
  late final Future<List<Mycancelappointment>?> fetchcancelappointment4;

  // late final Future<List<DenemeCard>?> cardim;
  List<Mycancelappointment>? iptaledilenrandevular;
  Kullanicibilgisi? kullanicibilgim;
  Hizmetbilgisi? hizmetbilgim;
  Tesisbilgisi? tesisbilgim;
  Map<int, DenemeCard> denemecardim = {};

  getUser() async {
    myusermodel = await SharedDataService().getLoginData();
  }

  /////
  Future<List<Mycancelappointment>?> canceledRandevuList() async {
    await getUser();
    final url = 'https://$apiBaseUrl/api/randevu/olustur/index.php';
    const headers = {
      'Authorization': 'Basic cm9vdEBnZWNpczM2MC5jb206MTIzNDEyMzQ=',
      'PHPSESSID': '0ms1fk84dssk9s3mtfmmdsjq24',
    };
    final body = {'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as', 'iptaledilenrandevular': '1', 'kullanici_id': '25'};

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      print(response.toString());
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        iptaledilenrandevular = jsonData.map((item) => Mycancelappointment.fromJson(item)).toList();
        return iptaledilenrandevular;
      } else {}
    } catch (e) {
      throw Exception('İstek sırasında hata oluştu: $e');
    }
    return null;
  }

  /////
  Future<DenemeCard> deneme({required Mycancelappointment appointment}) async {
    await getUser();
    final url = 'https://$apiBaseUrl/api/genel/index.php';
    const headers = {
      'Authorization': 'Basic cm9vdEBnZWNpczM2MC5jb206MTIzNDEyMzQ=',
      'PHPSESSID': '0ms1fk84dssk9s3mtfmmdsjq24',
    };

    final body = {
      'token': 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as',
      'kullanicibilgisi': appointment.kullaniciId?.toString()
    };
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
    fetchcancelappointment4 = canceledRandevuList();
    // cardim = deneme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Sola yaslama
          children: [
            const SizedBox(height: 10),
            FutureBuilder<List<Mycancelappointment>?>(
              future: fetchcancelappointment4,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return data.isEmpty
                      ? IptalEdilenRandevuCard()
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
                                      ));
                                    } else if (snapshot2.hasError) {
                                      return Center(child: Text('Hata: ${snapshot2.error}'));
                                    } else if (snapshot2.hasData) {
                                      final data2 = snapshot2.data!;
                                      final bet = data2;

                                      return AppointmentCard(
                                        buttonText: "İptal Edilen Randevu",
                                        title: bet.tesisbilgisimodel?.tesisAd ?? "",
                                        subtitle: bet.hizmetbilgisimodel?.hizmetAd ?? "",
                                        date: appointment.timestamp?.split(" ").first.toString() ?? "",
                                        startTime: bet.hizmetbilgisimodel?.aktifsaatBaslangic ?? "",
                                        endTime: bet.hizmetbilgisimodel?.aktifsaatBitis ?? "",
                                        onButtonPressed: () {
                                          // Randevuya tıklama işlemi
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
  }
}
