import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../const/const.dart';

class AppointmentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date; // Tarih String formatında (API'den geldiği gibi)
  final String startTime; // Başlangıç saati
  final String endTime; // Bitiş saati
  final String buttonText;
  final VoidCallback onButtonPressed;

  const AppointmentCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.buttonText,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
            ),
            Text(subtitle, style: TextStyle(fontSize: 14, color: primaryColor)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoBox((date.split("-").reversed.join("-")), Icons.calendar_today),
                _buildInfoBox(startTime.formattedDate, Icons.access_time),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 193, 196, 231),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color.fromARGB(255, 70, 88, 255)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(color: Color.fromARGB(255, 70, 88, 255)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tarihi formatlayan fonksiyon (API'den gelen String'i işler)
  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date); // String'i DateTime'a dönüştür
      return DateFormat('dd/MM/yyyy').format(parsedDate); // İstenen formata çevir
    } catch (e) {
      return date; // Hata olursa orijinal tarihi göster
    }
  }

  // Saat aralığını formatlayan fonksiyon
  String _formatTimeRange(String start, String end) {
    try {
      /*
      final parsedStart = DateTime.parse('1970-01-01 $start:00');
      final parsedEnd = DateTime.parse('1970-01-01 $end:00');
      final formattedStart = DateFormat('HH:mm').format(parsedStart);
      final formattedEnd = DateFormat('HH:mm').format(parsedEnd);
      return '$formattedStart - $formattedEnd'; // Örnek: "12:00 - 12:30"*/
      return '$start - $end';
    } catch (e) {
      return '$start - $end'; // Hata olursa orijinal değerleri göster
    }
  }

  // Bilgi kutusu tasarımı
  Widget _buildInfoBox(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // Saatin yalnızca "HH:mm" kısmını almak için yardımcı bir fonksiyon
  String _extractTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return "Bilinmiyor";
    try {
      return dateTime.split(" ").last.substring(0, 5); // "HH:mm" kısmını alır
    } catch (e) {
      return "Bilinmiyor";
    }
  }
}

extension DateTimeParser on String {
  String get formattedDate {
    try {
      final parsedDate = DateTime.parse(this);
      return DateFormat('HH:mm').format(parsedDate);
    } catch (e) {
      return this;
    }
  }
}
