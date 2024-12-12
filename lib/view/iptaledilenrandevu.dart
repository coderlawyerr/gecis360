// import 'package:armiyaapp/providers/appoinment/appoinment_provider.dart';
// import 'package:armiyaapp/providers/iptal_randevu_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class Iptaledilenrandevu extends StatefulWidget {
//   const Iptaledilenrandevu({super.key});

//   @override
//   State<Iptaledilenrandevu> createState() => _IptaledilenrandevuState();
// }

// class _IptaledilenrandevuState extends State<Iptaledilenrandevu> {
//   @override
//   Widget build(BuildContext context) {
//     var iptalRandevuProvider = Provider.of<IptalRandevuProvider>(context);

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 50),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: iptalRandevuProvider.iptaledilenrandevum.length,
//                 itemBuilder: (context, index) {
//                   final randevu = iptalRandevuProvider.iptaledilenrandevum[index];

//                   return ListTile(
//                     title: Text(randevu.hizmetId.toString()),
//                     // Diğer alanlar...
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:armiyaapp/providers/iptal_randevu_provider.dart';

class Iptaledilenrandevu extends StatelessWidget {
  const Iptaledilenrandevu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İptal Edilen Randevular'),
      ),
      body: Consumer<IptalRandevuProvider>(
        builder: (context, iptalRandevuProvider, child) {
          if (iptalRandevuProvider.iptaledilenrandevum.isEmpty) {
            return Center(child: Text('İptal edilen randevu bulunmamaktadır.'));
          }
          return ListView.builder(
            itemCount: iptalRandevuProvider.iptaledilenrandevum.length,
            itemBuilder: (context, index) {
              final randevu = iptalRandevuProvider.iptaledilenrandevum[index];
              return ListTile(
                title: Text('Randevu ID: ${randevu.randevuId}'),
                subtitle: Text('Hizmet ID: ${randevu.hizmetId}'),
                // Diğer randevu bilgilerini buraya ekleyebilirsiniz
              );
            },
          );
        },
      ),
    );
  }
}