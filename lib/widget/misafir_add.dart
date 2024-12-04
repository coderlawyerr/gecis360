// import 'package:armiyaapp/providers/appoinment/misafir_add_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/services.dart'; // TextInputFormatter için

// class MisafirAdd extends StatefulWidget {
//   const MisafirAdd({super.key});

//   @override
//   _MisafirAddState createState() => _MisafirAddState();
// }

// class _MisafirAddState extends State<MisafirAdd> {
//   List<Map<String, String>> misafirKartlari = [];
//   List<DateTime> confirmedTimeSlots = [];
//   List<DateTime> timeSlots = [];

//   final TextEditingController tcController = TextEditingController();
//   final TextEditingController adSoyadController = TextEditingController();
//   final TextEditingController telefonController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadMisafirKartlari();
//     _generateTimeSlots();
//   }

//   void _generateTimeSlots() {
//     for (int i = 0; i < 10; i++) {
//       timeSlots.add(DateTime.now().add(Duration(hours: i)));
//     }
//   }

//   Color getTimeSlotColor(DateTime timeSlot) {
//     if (confirmedTimeSlots.contains(timeSlot)) {
//       return Colors.green;
//     }
//     return Colors.blue;
//   }

//   Future<void> _sendData(
//     String tc,
//     String adSoyad,
//     String telefon,
//     String email,
//   ) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();

//     setState(() {
//       misafirKartlari.add({
//         'tc': tc,
//         'adSoyad': adSoyad,
//         'telefon': telefon,
//         'email': email,
//         'isConfirmed': 'false',
//       });
//     });
//     await prefs.setString('misafirBilgileri', json.encode(misafirKartlari));

//     final url = Uri.parse('https://$apiBaseUrl/api/randevu/olustur/index.php');
//     final token = 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as';

//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: json.encode({
//         'tc': tc,
//         'adSoyad': adSoyad,
//         'telefon': telefon,
//         'email': email,
//       }),
//     );

//     if (response.statusCode == 200) {
//       print('Veri başarıyla gönderildi: ${response.body}');
//     } else {
//       print('POST isteği başarısız: ${response.statusCode}');
//       print('Yanıt: ${response.body}');
//     }
//   }

//   Future<void> _loadMisafirKartlari() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? misafirJson = prefs.getString('misafirBilgileri');
//     if (misafirJson != null) {
//       setState(() {
//         misafirKartlari = List<Map<String, String>>.from(
//           json.decode(misafirJson).map((item) => Map<String, String>.from(item as Map<String, dynamic>)),
//         );
//       });
//     }
//   }

//   Future<void> _removeMisafirFromPrefs(String tc) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       misafirKartlari.removeWhere((misafir) => misafir['tc'] == tc);
//     });
//     await prefs.setString('misafirBilgileri', json.encode(misafirKartlari));
//   }

//   Widget _buildMisafirCard(Map<String, String> misafir) {
//     final tcController = TextEditingController(text: misafir['tc']);
//     final adSoyadController = TextEditingController(text: misafir['adSoyad']);
//     final telefonController = TextEditingController(text: misafir['telefon']);
//     final emailController = TextEditingController(text: misafir['email']);

//     return Card(
//       elevation: 10,
//       color: Color.fromARGB(255, 203, 207, 243),
//       margin: EdgeInsets.all(10),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Text(
//               "MİSAFİR",
//               style: TextStyle(fontSize: 25, color: Colors.black87),
//             ),
//             Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () {
//                     _removeMisafirFromPrefs(tcController.text);
//                   },
//                 ),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       _buildTextField(label: "Misafir TC", controller: tcController),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       _buildTextField(label: "Ad Soyad", controller: adSoyadController),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       _buildTextField(label: "Telefon Numarası", controller: telefonController),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       _buildTextField(label: "E-posta", controller: emailController),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({required String label, required TextEditingController controller}) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(),
//       ),
//       keyboardType: label == 'Misafir TC' || label == 'Telefon Numarası' ? TextInputType.number : TextInputType.text,
//       inputFormatters: label == 'Misafir TC' || label == 'Telefon Numarası' ? [FilteringTextInputFormatter.digitsOnly] : [],
//     );
//   }

//   void _addNewMisafirCard() {
//     tcController.clear();
//     adSoyadController.clear();
//     telefonController.clear();
//     emailController.clear();
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Misafir Ekle'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildTextField(label: 'Misafir TC', controller: tcController),
//               SizedBox(
//                 height: 10,
//               ),
//               _buildTextField(label: 'Ad Soyad', controller: adSoyadController),
//               SizedBox(
//                 height: 10,
//               ),
//               _buildTextField(label: 'Telefon Numarası', controller: telefonController),
//               SizedBox(
//                 height: 10,
//               ),
//               _buildTextField(label: 'E-posta', controller: emailController),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('İptal'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (tcController.text.isNotEmpty && adSoyadController.text.isNotEmpty && telefonController.text.isNotEmpty && emailController.text.isNotEmpty) {
//                   _sendData(
//                     tcController.text,
//                     adSoyadController.text,
//                     telefonController.text,
//                     emailController.text,
//                   );
//                   Navigator.pop(context);
//                 } else {
//                   print('Tüm alanların doldurulması gereklidir.');
//                 }
//               },
//               child: Text('Ekle'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showSaveDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Kaydetme İşlemi'),
//           content: Text('Kaydetmek istediğinize emin misiniz?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('İptal'),
//             ),
//             TextButton(
//               onPressed: () {
//                 context.read<MisafirAddProvider>().loadMisafirler();
//                 _saveData();
//                 Navigator.pop(context);
//               },
//               child: Text('Kaydet'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _saveData() {
//     // Misafir bilgilerini kaydetme işlemi burada yapılabilir.
//     print("Veriler kaydedildi.");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("Misafir Ekleme"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: misafirKartlari.map((misafir) => _buildMisafirCard(misafir)).toList(),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color.fromARGB(255, 134, 147, 247),
//               minimumSize: Size(30, 55), // Genişlik ve yükseklik
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8), // Köşe yuvarlama
//               ),
//             ),
//             onPressed: _showSaveDialog,
//             child: Text(
//               'Kaydet',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//           SizedBox(width: 10),
//           Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: SizedBox(
//               width: 85, // İstediğiniz genişlik
//               height: 55, // İstediğiniz yükseklik
//               child: FloatingActionButton(
//                 backgroundColor: Color.fromARGB(255, 134, 147, 247), // Arka plan rengi
//                 onPressed: _addNewMisafirCard,
//                 child: Icon(
//                   Icons.add,
//                   color: Colors.white,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8), // Köşe yuvarlama
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:armiyaapp/providers/appoinment/misafir_add_provider.dart';
import 'package:armiyaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // TextInputFormatter için

class MisafirAdd extends StatefulWidget {
  const MisafirAdd({super.key});

  @override
  _MisafirAddState createState() => _MisafirAddState();
}

class _MisafirAddState extends State<MisafirAdd> {
  List<Map<String, String>> misafirKartlari = [];
  List<DateTime> confirmedTimeSlots = [];
  List<DateTime> timeSlots = [];

  final TextEditingController tcController = TextEditingController();
  final TextEditingController adSoyadController = TextEditingController();
  final TextEditingController telefonController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMisafirKartlari();
    _generateTimeSlots();
  }

  void _generateTimeSlots() {
    for (int i = 0; i < 10; i++) {
      timeSlots.add(DateTime.now().add(Duration(hours: i)));
    }
  }

  Color getTimeSlotColor(DateTime timeSlot) {
    if (confirmedTimeSlots.contains(timeSlot)) {
      return Colors.green;
    }
    return Colors.blue;
  }

  Future<void> _sendData(
    String tc,
    String adSoyad,
    String telefon,
    String email,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      misafirKartlari.add({
        'tc': tc,
        'adSoyad': adSoyad,
        'telefon': telefon,
        'email': email,
        'isConfirmed': 'false',
      });
    });
    await prefs.setString('misafirBilgileri', json.encode(misafirKartlari));

    final url = Uri.parse('https://$apiBaseUrl/api/randevu/olustur/index.php');
    final token = 'Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as';

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'tc': tc,
        'adSoyad': adSoyad,
        'telefon': telefon,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      print('Veri başarıyla gönderildi: ${response.body}');
    } else {
      print('POST isteği başarısız: ${response.statusCode}');
      print('Yanıt: ${response.body}');
    }
  }

  Future<void> _loadMisafirKartlari() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? misafirJson = prefs.getString('misafirBilgileri');
    if (misafirJson != null) {
      setState(() {
        misafirKartlari = List<Map<String, String>>.from(
          json.decode(misafirJson).map((item) => Map<String, String>.from(item as Map<String, dynamic>)),
        );
      });
    }
  }

  Future<void> _removeMisafirFromPrefs(String tc) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      misafirKartlari.removeWhere((misafir) => misafir['tc'] == tc);
    });
    await prefs.setString('misafirBilgileri', json.encode(misafirKartlari));
  }

  Widget _buildMisafirCard(Map<String, String> misafir) {
    final tcController = TextEditingController(text: misafir['tc']);
    final adSoyadController = TextEditingController(text: misafir['adSoyad']);
    final telefonController = TextEditingController(text: misafir['telefon']);
    final emailController = TextEditingController(text: misafir['email']);

    return Card(
      elevation: 10,
      color: Color.fromARGB(255, 203, 207, 243),
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "MİSAFİR",
              style: TextStyle(fontSize: 25, color: Colors.black87),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _removeMisafirFromPrefs(tcController.text);
                  },
                ),
                Expanded(
                  child: Column(
                    children: [
                      _buildTextField(label: "Misafir TC", controller: tcController),
                      SizedBox(
                        height: 10,
                      ),
                      _buildTextField(label: "Ad Soyad", controller: adSoyadController),
                      SizedBox(
                        height: 10,
                      ),
                      _buildTextField(label: "Telefon Numarası", controller: telefonController),
                      SizedBox(
                        height: 10,
                      ),
                      _buildTextField(label: "E-posta", controller: emailController),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: label == 'Misafir TC' || label == 'Telefon Numarası' ? TextInputType.number : TextInputType.text,
      inputFormatters: label == 'Misafir TC' || label == 'Telefon Numarası' ? [FilteringTextInputFormatter.digitsOnly] : [],
    );
  }

  void _addNewMisafirCard() {
    tcController.clear();
    adSoyadController.clear();
    telefonController.clear();
    emailController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Misafir Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(label: 'Misafir TC', controller: tcController),
              SizedBox(
                height: 10,
              ),
              _buildTextField(label: 'Ad Soyad', controller: adSoyadController),
              SizedBox(
                height: 10,
              ),
              _buildTextField(label: 'Telefon Numarası', controller: telefonController),
              SizedBox(
                height: 10,
              ),
              _buildTextField(label: 'E-posta', controller: emailController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (tcController.text.isNotEmpty && adSoyadController.text.isNotEmpty && telefonController.text.isNotEmpty && emailController.text.isNotEmpty) {
                  _sendData(
                    tcController.text,
                    adSoyadController.text,
                    telefonController.text,
                    emailController.text,
                  );
                  Navigator.pop(context);
                } else {
                  print('Tüm alanların doldurulması gereklidir.');
                }
              },
              child: Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kaydetme İşlemi'),
          content: Text('Kaydetmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                context.read<MisafirAddProvider>().loadMisafirler();
                _saveData();
                Navigator.pop(context);
              },
              child: Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  void _saveData() {
    // Misafir bilgilerini kaydetme işlemi burada yapılabilir.
    print("Veriler kaydedildi.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Misafir Ekleme"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: misafirKartlari.map((misafir) => _buildMisafirCard(misafir)).toList(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 134, 147, 247),
              minimumSize: Size(30, 55), // Genişlik ve yükseklik
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Köşe yuvarlama
              ),
            ),
            onPressed: _showSaveDialog,
            child: Text(
              'Kaydet',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              width: 85, // İstediğiniz genişlik
              height: 55, // İstediğiniz yükseklik
              child: FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 134, 147, 247), // Arka plan rengi
                onPressed: _addNewMisafirCard,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Köşe yuvarlama
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
