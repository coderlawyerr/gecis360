// // lib/widget/dropdown.dart

 
// import 'package:armiyaapp/view/appoinment/appointment_calender/model/facility_model.dart';
// import 'package:flutter/material.dart';

// class CustomDropdown extends StatelessWidget {
//   final String hintText;
//   final List<FacilityModel>? items;
//   final String? selectedItem;
//   final ValueChanged<String?> onChanged;
//   final String? Function(String?)? validator;

//   const CustomDropdown({
//     super.key,
//     required this.hintText,
//     required this.items,
//     required this.selectedItem,
//     required this.onChanged,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(),
//         contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       ),
//       hint: Text(hintText),
//       value: selectedItem,
//       isExpanded: true,
//       items: items?.map(( val) {
//         return DropdownMenuItem<String>(
//           value: val.
//           child: Text(val.tesisAd!),
//         );
//       }).toList() ?? [],
//       onChanged: onChanged,
//       validator: validator,
//     );
//   }
// }
