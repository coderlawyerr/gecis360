import 'package:flutter/material.dart';

class CustomEventList extends StatelessWidget {
  final List<Map<String, dynamic>> eventData;

  const CustomEventList({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: eventData.map((data) {
        return ExpansionTile(
          title: Text(
            data['date'] as String,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          children: (data['events'] as List<Map<String, String>>).map((event) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['eventName']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text('Hizmet adı: ${event['serviceType']}'),
                    const SizedBox(height: 8.0),
                    Text(
                      'Başlangıç Saati: ${event['startTime']}  Bitiş Saati: ${event['endTime']}',
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
