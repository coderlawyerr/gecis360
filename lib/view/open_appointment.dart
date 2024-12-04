
import 'package:armiyaapp/widget/switch.dart';
import 'package:flutter/material.dart';
import 'package:armiyaapp/widget/open_appoinmentwidget.dart';
import 'package:armiyaapp/widget/text.dart';
import 'package:armiyaapp/widget/textfield.dart';


class OpenAppointment extends StatefulWidget {
  const OpenAppointment({super.key});

  @override
  State<OpenAppointment> createState() => _OpenAppointmentState();
}

class _OpenAppointmentState extends State<OpenAppointment> {
  final TextEditingController facilityController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  bool status = false;
  @override
  void dispose() {
    // Controller'ları sayfa kapandığında temizle
    facilityController.dispose();
    serviceController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    startTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Randevu Ayarla"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            const   Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OpenAppointmentWidget(
                    text: 'Mevcut randevu: 0',
                    textColor: Colors.black,
                    borderColor: Colors.grey,
                    borderRadius: 8.0,
                  ),
                  OpenAppointmentWidget(
                    text: 'Kalan randevu: 5',
                    textColor: Colors.black,
                    borderColor: Colors.grey,
                    borderRadius: 8.0,
                  ),
                ],
              ),
           
              const SizedBox(height:20 ,),
              const CustomText(text: "Tesis Adı"),
              CustomTextField(
                hintText: "Tesis Adı Giriniz",
                controller: facilityController,
              ),
              const SizedBox(height: 10),
              const CustomText(text: "Hizmet Türü"),
              CustomTextField(
                hintText: "Hizmet Türü Giriniz",
                controller: serviceController,
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              Row(
                children: [
                  const CustomText(text: "Başlangıç \n Saati"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      hintText: "Saat Giriniz",
                      controller: startTimeController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const CustomText(text: "Bitiş Tarihi"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      hintText: "GG/AA/YYYY",
                      controller: endDateController,
                    ),
                  ),
                ],
              ),
              const SwitchWidget(
                title: "Misafir Eklemek İstiyorum",
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
            //const GuestInfoDropdown(),
            ],
          ),
        ),
      ),
    );
  }
}
