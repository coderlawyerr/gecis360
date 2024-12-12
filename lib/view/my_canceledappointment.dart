// import 'package:armiyaapp/services/cancaled_appointment.dart';
// import 'package:armiyaapp/view/appoinment/appointment_calender/model/randevu_model.dart';
// import 'package:armiyaapp/widget/appointmentcard.dart';
// import 'package:flutter/material.dart';

// class MyCanceledappointment extends StatelessWidget {
//   final List<RandevuModel> canceledAppointments; // İptal edilen randevular

//   const MyCanceledappointment({super.key, required this.canceledAppointments});

//   Future<RandevuModel> iptaledilen({required RandevuModel appointment}) async {
//   //   CancaledAppointmentService iptaledilenrandevum CancaledAppointmentService();
//     return appointment;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('İptal Edilen Randevular'),
//       ),
//       body: ListView.builder(
//         itemCount: canceledAppointments.length,
//       //   itemBuilder: (context, index) {
//       //     final appointment = canceledAppointments[index];
//       //   //   return FutureBuilder<RandevuModel>(
//       //   //   // future: CancaledAppointment<>(),
//       //   //   //   builder: (BuildContext context, AsyncSnapshot snapshot) {
//       //   //   //     if (snapshot.connectionState == ConnectionState.waiting) {
//       //   //   //       return Center(child: CircularProgressIndicator());
//       //   //   //     } else if (snapshot.hasError) {
//       //   //   //       return Center(child: Text('Hata: ${snapshot.error}'));
//       //   //   //     } else if (snapshot.hasData) {
//       //   //   //       final canceledAppointment = snapshot.data!;
//       //   //   //       return AppointmentCard(
//       //   //   //         title: canceledAppointment.tesisId ?? "Tesis Adı Yok",
//       //   //   //         subtitle: canceledAppointment.hizmetAd ?? "Hizmet Adı Yok",
//       //   //   //         date: canceledAppointment.baslangicTarihi ?? "Tarih Yok",
//       //   //   //         startTime: canceledAppointment.baslangicSaati ?? "Başlangıç Saati Yok",
//       //   //   //         endTime: canceledAppointment.bitisSaati ?? "Bitiş Saati Yok",
//       //   //   //         buttonText: "Tekrar Randevu Al",
//       //   //   //         onButtonPressed: () {
//       //   //   //           // Tekrar randevu alma işlemi
//       //   //   //         },
//       //   //   //       );
//       //   //   //     } else {
//       //   //   //       return Center(child: Text('Veri yok'));
//       //   //   //     }
//       //   //   //   },
//       //   //   // );
//       //   // },
//       // ),
//     );
//   }
// }