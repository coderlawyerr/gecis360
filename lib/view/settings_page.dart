import 'dart:convert';
import 'package:armiyaapp/const/const.dart';
import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/model/usermodel.dart';
import 'package:armiyaapp/services/auth_service.dart';
import 'package:armiyaapp/utils/constants.dart';
import 'package:armiyaapp/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'edit_page.dart';
import 'login.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedDataService sharedDataService = SharedDataService();
    final data = await sharedDataService.getLoginData();
    if (data == null) {
    } else {
      print("Kullanıcı verisi alındı: ${data.isimsoyisim}");
    }
    setState(() {
      userModel = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: userModel == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 60, right: 10, left: 10),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(25),
                              child: CircleAvatar(
                                backgroundColor: Color.fromARGB(255, 227, 226, 226),
                                radius: 30,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              userModel?.isimsoyisim ?? 'Yükleniyor...',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EditProfilPage()), // EditPage yönlendirme
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: primaryColor,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: const Row(
                              children: [
                                Icon(Icons.edit, color: Colors.black),
                                SizedBox(width: 10),
                                Text(
                                  "Profili Düzenle",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Card(
                    elevation: 4,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: ListTile(
                        leading: const Icon(Icons.door_back_door_outlined),
                        title: const Text("Çıkış Yap", style: TextStyle(fontSize: 15)),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        onTap: () {
                          // Çıkış yapmadan önce onay penceresi göster
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Çıkış Yapmak Üzeresiniz?"),
                                content: const Text("Çıkış yapmak istediğinizden emin misiniz?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      final GlobalKey<HomePageState> homePageKey = GlobalKey<HomePageState>();
                                      // Çıkış yapmaya karar verildiğinde LoginPage'e yönlendir

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage(
                                                  key: homePageKey,
                                                )),
                                      );
                                    },
                                    child: Text(
                                      "Evet",
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Dialogu kapat
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Hayır",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}










































































// import 'dart:convert';
// import 'package:armiyaapp/const/const.dart';
// import 'package:armiyaapp/data/app_shared_preference.dart';
// import 'package:armiyaapp/model/usermodel.dart';
// import 'package:armiyaapp/services/auth_service.dart';
// import 'package:armiyaapp/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'edit_page.dart';
// import 'login.dart';

// class SettingPage extends StatefulWidget {
//   const SettingPage({super.key});
//   @override
//   _SettingPageState createState() => _SettingPageState();
// }

// class _SettingPageState extends State<SettingPage> {
//   UserModel? userModel;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     SharedDataService sharedDataService = SharedDataService();
//     final data = await sharedDataService.getLoginData();
//     if (data == null) {
//     } else {
//       print("Kullanıcı verisi alındı: ${data.isimsoyisim}");
//     }
//     setState(() {
//       userModel = data;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: userModel == null
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.only(top: 60, right: 10, left: 10),
//               child: Column(
//                 children: [
//                   Card(
//                     color: Colors.white,
//                     elevation: 4,
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             const Padding(
//                               padding: EdgeInsets.all(25),
//                               child: CircleAvatar(
//                                 backgroundColor: Color.fromARGB(255, 227, 226, 226),
//                                 radius: 30,
//                               ),
//                             ),
//                             const SizedBox(width: 5),
//                             Text(
//                               userModel?.isimsoyisim ?? 'Yükleniyor...',
//                               style: const TextStyle(fontSize: 18),
//                             ),
//                           ],
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                             color: Color.fromARGB(255, 224, 222, 222),
//                           ),
//                           margin: const EdgeInsets.symmetric(horizontal: 20),
//                           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => EditProfilPage()), // EditPage yönlendirme
//                               );
//                             },
//                             child: Row(
//                               children: [
//                                 const Icon(Icons.edit, color: Colors.black),
//                                 const SizedBox(width: 10),
//                                 Text(
//                                   "Profili Düzenle",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.normal,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8),
//                     child: ListTile(
//                       leading: const Icon(Icons.door_back_door_outlined),
//                       title: const Text("Çıkış Yap", style: TextStyle(fontSize: 15)),
//                       tileColor: Colors.white,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       onTap: () {
//                         // Çıkış yapmadan önce onay penceresi göster
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: const Text("Çıkış Yapmak Üzeresiniz?"),
//                               content: const Text("Çıkış yapmak istediğinizden emin misiniz?"),
//                               actions: <Widget>[
//                                 TextButton(
//                                   onPressed: () {
//                                     // Çıkış yapmaya karar verildiğinde LoginPage'e yönlendir
//                                     Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(builder: (context) => LoginPage()),
//                                     );
//                                   },
//                                   child: Text(
//                                     "Evet",
//                                     style: TextStyle(color: primaryColor),
//                                   ),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     // Dialogu kapat
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: const Text(
//                                     "Hayır",
//                                     style: TextStyle(color: Colors.grey),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
