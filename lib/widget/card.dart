import 'package:flutter/material.dart';

class ScheduleDropdown extends StatefulWidget {
  const ScheduleDropdown({super.key});

  @override
  _ScheduleDropdownState createState() => _ScheduleDropdownState();
}

class _ScheduleDropdownState extends State<ScheduleDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "23.10.2024",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Column(
              children: [
                _buildCard(
                  "Mahide Hatun Spor Kompleksi",
                  "Fitness Salonu",
                  "09:30",
                  "11:00",
                ),
                _buildCard(
                  "Mahide Hatun Spor Kompleksi",
                  "Sauna",
                  "12:30",
                  "13:15",
                ),
                _buildCard(
                  "Galata Spor ve Eğlence Merkezi",
                  "Fitness Salonu",
                  "15:30",
                  "17:00",
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCard(
      String title, String serviceName, String startTime, String endTime) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Hizmet adı: $serviceName"),
            const SizedBox(height: 4),
            Text("Başlangıç Saati: $startTime"),
            Text("Bitiş Saati: $endTime"),
          ],
        ),
      ),
    );
  }
}
