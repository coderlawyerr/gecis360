import 'package:armiyaapp/services/kayit_service.dart';
import 'package:flutter/material.dart';
import 'package:armiyaapp/data/app_shared_preference.dart';
import 'package:armiyaapp/model/kayit_model.dart';

import 'package:armiyaapp/const/const.dart';

class StaticTablePage extends StatefulWidget {
  @override
  _StaticTablePageState createState() => _StaticTablePageState();
}

class _StaticTablePageState extends State<StaticTablePage> {
  int _currentPage = 0;
  final int _rowsPerPage = 10;
  List<kayit> _data = [];

  // Servisi çağırarak veri çekme
  Future<void> _fetchData() async {
    try {
      List<kayit> kayitlar = await KayitOlustur().kayitolustur();
      setState(() {
        _data = kayitlar;
      });
    } catch (e) {
      // Hata durumunda kullanıcıyı bilgilendirebiliriz
      print("Veri çekme hatası: $e");
    }
  }

  // Şu anki sayfanın verisini almak
  List<kayit> _getCurrentPageData() {
    int startIndex = _currentPage * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    if (endIndex > _data.length) endIndex = _data.length;
    return _data.sublist(startIndex, endIndex);
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Veriyi çekmek için servis çağrısını yapıyoruz
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 70, left: 5, right: 5),
          child: Column(
            children: [
              Text(
                "Kayıtlarınız",
                style: TextStyle(color: Colors.grey, fontSize: 35),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 4,
                child: Container(
                  padding: EdgeInsets.only(top: 25),
                  height: height / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Hizmet')),
                                DataColumn(label: Text('Üye')),
                                DataColumn(label: Text('Giriş Saati')),
                                DataColumn(label: Text('Çıkış Saati')),
                                DataColumn(label: Text('Geçirilen Süre')),
                                DataColumn(label: Text('Durum')),
                              ],
                              rows: _getCurrentPageData().map<DataRow>((data) {
                                return DataRow(cells: [
                                  DataCell(Text(data.hizmetAd ?? "")),
                                  DataCell(Text(data.kullaniciIsimsoyisim ?? "")),
                                  DataCell(Text(data.girisTarihi ?? "")),
                                  DataCell(Text(data.cikisTarihi ?? "")),
                                  DataCell(Text(data.gecirilenSure ?? "")),
                                  DataCell(Text(data.gecirilenSureRenk == "SUCCESS" ? "Başarılı Giriş Yapıldı" : "Giriş Başarısız")),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.grey,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: _currentPage > 0
                        ? () {
                            setState(() {
                              _currentPage--;
                            });
                          }
                        : null,
                  ),
                  Text('Sayfa ${_currentPage + 1}'),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: (_currentPage + 1) * _rowsPerPage < _data.length
                        ? () {
                            setState(() {
                              _currentPage++;
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
