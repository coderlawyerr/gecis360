import 'package:armiyaapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RandevuDropdown extends StatefulWidget {
  final String tesisId; // CustomDropdown'dan gelen tesis ID'si
  const RandevuDropdown({super.key, required this.tesisId});

  @override
  State<RandevuDropdown> createState() => _RandevuDropdownState();
}

class User {
  final String name;
  final int id;
  User({required this.name, required this.id});
  @override
  String toString() {
    return 'User(name: $name, id: $id)';
  }
}

class _RandevuDropdownState extends State<RandevuDropdown> {
  /// o paketı  bır wıdget halıne getırmek ıstedım ve kullanmadım ama
  final _formKey = GlobalKey<FormState>();
  final controller = MultiSelectController<User>();
  List<User> userList = []; // API'den gelen kullanıcı verileri
  @override
  void initState() {
    super.initState();
    fetchRandevuItems(widget.tesisId); // Tesis ID'sine göre verileri çek
  }

  Future<void> fetchRandevuItems(String tesisId) async {
    final response = await http.get(Uri.parse('YOUR_API_URL/$tesisId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        userList = jsonResponse
            .map((item) => User(
                  name: item['name'],
                  id: item['id'],
                ))
            .toList();
      });
    } else {
      throw Exception('Failed to load randevu items');
    }
  }

  Future<void> postTesisId(String tesisId) async {
    final response = await http.post(
      Uri.parse('https://$apiBaseUrl/api/randevu/olustur/index.php'), // POST isteği yapacağınız URL
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: jsonEncode(<String, String>{'tesissecim ': tesisId, 'token': "Ntss5snV5IcOngbykluMqLqHqQzgqe5zo5as"}),
    );
    if (response.statusCode == 200) {
      // Gelen yanıtı işleyin ve dropdown verilerini güncelleyin
      List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        userList = jsonResponse
            .map((item) => User(
                  name: item['name'],
                  id: item['id'],
                ))
            .toList();
      });
    } else {
      throw Exception('Failed to post tesis ID');
    }
  }

  List<DropdownItem<User>> _buildDropdownItems() {
    return userList.map((user) {
      return DropdownItem(label: user.name, value: user);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          MultiDropdown<User>(
            items: _buildDropdownItems(),
            controller: controller,
            enabled: true,
            searchEnabled: true,
            chipDecoration: const ChipDecoration(
              backgroundColor: Colors.yellow,
              wrap: true,
              runSpacing: 2,
              spacing: 10,
            ),
            fieldDecoration: FieldDecoration(
              hintText: 'Select Services',
              hintStyle: const TextStyle(color: Colors.black87),
              showClearIcon: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.black87,
                ),
              ),
            ),
            dropdownDecoration: const DropdownDecoration(
              marginTop: 2,
              maxHeight: 500,
              header: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Select services from the list',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            dropdownItemDecoration: DropdownItemDecoration(
              selectedIcon: const Icon(Icons.check_box, color: Colors.green),
              disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a service';
              }
              return null;
            },
            onSelectionChange: (selectedItems) {
              debugPrint("OnSelectionChange: $selectedItems");
              // Seçim değiştiğinde tesis ID'sini post et
              if (selectedItems.isNotEmpty) {
                postTesisId(widget.tesisId);
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
