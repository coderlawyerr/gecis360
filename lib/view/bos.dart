import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: Base64Converter(),
      );
}

class Base64Converter extends StatefulWidget {
  const Base64Converter({super.key});

  @override
  _Base64ConverterState createState() => _Base64ConverterState();
}

class _Base64ConverterState extends State<Base64Converter> {
  String? _base64String;
  File? _selectedImage; // Kullanıcının seçtiği resim

  Future<void> _pickAndConvertImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await File(image.path).readAsBytes();

      setState(() {
        _base64String = base64Encode(bytes);
        _selectedImage = File(image.path); // Resmi kaydet
      });

      print('Base64 String: $_base64String');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Base64 Dönüştürücü'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _pickAndConvertImage,
                child: const Text('Resim Seç ve Base64 Dönüştür'),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipOval(
                    child: Image.file(
                      _selectedImage!,
                      height: 200, // Yuvarlak görüntü için boyut
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (_base64String != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Base64 String:\n$_base64String',
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
