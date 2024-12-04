import 'package:armiyaapp/const/const.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 2,
          items: <Widget>[
            Icon(Icons.cancel,
                size: 30, color: Colors.white), // İptal Edilen Randevular

            Icon(
              Icons.check_circle,
              size: 30,
              color: Colors.white,
            ), // Aktif Randevular
            Icon(Icons.calendar_today,
                size: 30, color: Colors.white), // Randevu Oluştur
            Icon(Icons.history,
                size: 30, color: Colors.white), // Geçmiş Randevular
            Icon(Icons.qr_code, size: 30, color: Colors.white), // QR Kod
          ],
          color: primaryColor,
          buttonBackgroundColor: primaryColor,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 500),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(_page.toString(), style: TextStyle(fontSize: 160)),
                ElevatedButton(
                  child: Text('Go To Page of index 1'),
                  onPressed: () {
                    final CurvedNavigationBarState? navBarState =
                        _bottomNavigationKey.currentState;
                    navBarState?.setPage(1);
                  },
                )
              ],
            ),
          ),
        ));
  }
}
