import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final String? suffixText; // İsteğe bağlı suffix metni
  final Widget? suffixIcon; // İkon için ekledik
  final bool obscureText; // Bu satırı ekleyin
  final TextEditingController controller; // Controller
  final String? Function(String?)? validator;
  final TextInputType? keyboardType; // Klavye tipi için parametre

  const CustomTextField({
    required this.hintText,
    this.isPassword = false,
    this.suffixText,
    this.suffixIcon,
     this.obscureText = false, // Varsayılan olarak false, şifre alanlarında true olur
    // Bu özellik gerekli

    required this.controller,
    this.validator,
    this.keyboardType, // Klavye tipi isteğe bağlı
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1, // Ekranın 3'te biri genişlikte
      child: TextFormField(
         obscureText: isPassword ? obscureText : false, // Eğer şifre ise, obscureText kullanılacak
        controller: controller,
      
        keyboardType: keyboardType ,
        decoration: InputDecoration(
          hintText: hintText,
          suffixText: suffixText,
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
        ),
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen bu alanı doldurun'; // Uyarı mesajı
              }
              return null;
            },
      ),
    );
  }
}
