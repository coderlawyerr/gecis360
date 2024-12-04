
import 'package:armiyaapp/providers/appoinment/membergroups_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemeberGroups extends StatefulWidget {
  MemeberGroups({super.key});

  @override
  State<MemeberGroups> createState() => _MemeberGroupsState();
}

class _MemeberGroupsState extends State<MemeberGroups> {
  bool isChecked = false; // Başlangıç değeri false olarak ayarlandı.

  @override
  void initState (){
    super.initState();
    Provider.of<MemberGroupsProvider>(context,listen:false).fetchMemberGroups();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body:Consumer<MemberGroupsProvider> (
        builder: (context,provider,child) {
          if(provider.isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          return Padding(
            padding: EdgeInsets.only(top: 100, left: 25, right: 25),
            child: Column(
              children: [
                Card(
                  color: Color.fromARGB(255, 207, 211, 249),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 161, 172, 255),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (newBool) {
                                    setState(() {
                                      isChecked = newBool ?? false;
                                    });
                                  },
                                ),
                                Text(
                                  'armiya',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 166, 167, 175),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '4 kullanıcı',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Yetkili',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '• Root User (Siz)',
                                style: TextStyle(
                                  color: Color(0xFF5664D9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Üyeler',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4),
                              Wrap(
                                spacing: 8,
                                children: [
                                  Text('• Test Kullanıcısı'),
                                  Text('• Selami Şahin'),
                                  Text('• Şilan Kaya'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
