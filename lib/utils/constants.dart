import 'package:armiyaapp/services/markaHelper.dart';

String get apiBaseUrl => '${MarkaHelper.seciliMarkaAdi ?? "demo"}.gecis360.com';

const String createAppinmentEndPoint = '/randevu/olustur/index.php';
