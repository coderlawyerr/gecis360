import 'package:armiyaapp/model/new_model/newmodel.dart';
import 'package:flutter/material.dart';

class MemberGroupsProvider with ChangeNotifier {
  List<Bilgi> _bilgiler = [];
  bool _isLoading = true;

  List<Bilgi> get bilgiler => _bilgiler;
  bool get isLoading => _isLoading;

  Future<void> fetchMemberGroups() async {
    // try{
    //   //api istegi
    //   final response = await http.get (Uri.parse(""));

    //   if(response.statusCode ==200){
    //     final data = json.decode(response.body);
    //   }
    // }catch(eror){
    print("Hata:");
  }
}
