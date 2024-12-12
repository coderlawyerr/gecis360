import 'package:armiyaapp/const/const.dart';
import 'package:armiyaapp/services/forgot_service.dart';
import 'package:armiyaapp/widget/an%C4%B1masyonw%C4%B1dget.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  ForgotService _forgotService = ForgotService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20), // padding'i yukarıdan 70'ten 20'ye düşürdüm
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Dialogu kapat
                    },
                    color: primaryColor,
                    icon: Icon(Icons.arrow_back_ios_new_sharp),
                  ),
                  SizedBox(
                    width: 45,
                  ),
                  Text(
                    "Şifremi Unuttum",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              // ZiplamaAnimationWidget(
              //   imagePath: 'assets/mylock.png', // Burada resmin yolunu veriyoruz
              // ),
              Image(
                image: AssetImage("assets/lock.png"),
                height: 250,
                width: 250,
              ),
              SizedBox(height: 20),
              const Center(
                child: Text(
                  "Şifre sıfırlama talimatı almak için kayıtlı e-posta adresinizi aşağıya girin",
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'E posta adresini yaz',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 25),
              MaterialButton(
                onPressed: () async {
                  if (emailController.text.trim().isNotEmpty) {
                    bool kontrol = await _forgotService.forgotPassword(emailController.text.trim());
                    if (kontrol == true) {
                      final snackBar = SnackBar(
                        content: Text("Başarılı!"),
                        action: SnackBarAction(
                          label: "Geri Al",
                          onPressed: () {
                            // Aksiyon yapılırsa çağırılacak işlem
                            print("Geri al butonuna basıldı.");
                          },
                        ),
                        duration: Duration(seconds: 3), // Snackbar'ın görüneceği süre
                      );

                      // Snackbar'ı göster
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      final snackBar = SnackBar(
                        content: Text("Bu kullanıcı bulunamadı"),
                        action: SnackBarAction(
                          label: "Geri Al",
                          onPressed: () {
                            // Aksiyon yapılırsa çağırılacak işlem
                            print("Geri al butonuna basıldı.");
                          },
                        ),
                        duration: Duration(seconds: 3), // Snackbar'ın görüneceği süre
                      );
                      // Snackbar'ı göster
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Kenarların oval olma miktarını burada ayarlayın
                ),
                color: primaryColor,
                child: Text(
                  'Şifremi Yenile',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

















































// import 'package:armiyaapp/const/const.dart';
// import 'package:armiyaapp/services/forgot_service.dart';
// import 'package:flutter/material.dart';

// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({super.key});

//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }

// class _ForgotPasswordState extends State<ForgotPassword> {
//   TextEditingController emailController = TextEditingController();
//   ForgotService _forgotService = ForgotService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'Şifremi Unuttum',
//           style: TextStyle(
//             color: primaryColor,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               const Center(
//                 child: Text(
//                   "Şifresini unuttuğun e posta adresini aşağıya yazınız.",
//                   style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 20),
//                 ),
//               ),
//               const SizedBox(height: 50),
//               TextFormField(
//                 controller: emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   hintText: 'E posta adresini yaz',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(26)),
//                 ),
//               ),
//               const SizedBox(height: 25),
//               MaterialButton(
//                 onPressed: () async {
//                   if (emailController.text.trim().isNotEmpty) {
//                     bool kontrol = await _forgotService.forgotPassword(emailController.text.trim());
//                     if (kontrol == true) {
//                       final snackBar = SnackBar(
//                         content: Text("Başarılı!"),
//                         action: SnackBarAction(
//                           label: "Geri Al",
//                           onPressed: () {
//                             // Aksiyon yapılırsa çağırılacak işlem
//                             print("Geri al butonuna basıldı.");
//                           },
//                         ),
//                         duration: Duration(seconds: 3), // Snackbar'ın görüneceği süre
//                       );

//                       // Snackbar'ı göster
//                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                     } else {
//                       final snackBar = SnackBar(
//                         content: Text("Bu kullanıcı bulunamadı"),
//                         action: SnackBarAction(
//                           label: "Geri Al",
//                           onPressed: () {
//                             // Aksiyon yapılırsa çağırılacak işlem
//                             print("Geri al butonuna basıldı.");
//                           },
//                         ),
//                         duration: Duration(seconds: 3), // Snackbar'ın görüneceği süre
//                       );
//                       // Snackbar'ı göster
//                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                     }
//                   }
//                 },
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10), // Kenarların oval olma miktarını burada ayarlayın
//                 ),
//                 color: primaryColor,
//                 child: Text(
//                   'Şifreyi Yenile',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


