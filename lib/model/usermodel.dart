class UserModel {
  bool? status;
  String? message;
  // Kullanicibilgisi? kullanicibilgisi;
  int? id;
  String? isimsoyisim;
  String? yetkiGrubu;
  String? ozelYetkiler;
  String? markaAdi;

  UserModel(
      {this.status,
      this.message,
      // this.kullanicibilgisi,
      this.id,
      this.isimsoyisim,
      this.yetkiGrubu,
      this.ozelYetkiler});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // kullanicibilgisi = json['kullanicibilgisi'] != null
    //     ? Kullanicibilgisi.fromJson(json['kullanicibilgisi'])
    //     : null;
    markaAdi = json["markaadi"];
    id = json['ID'];
    isimsoyisim = json['isimsoyisim'];
    yetkiGrubu = json['yetki_Grubu'];
    ozelYetkiler = json['ozelYetkiler'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    // if (kullanicibilgisi != null) {
    //   data['kullanicibilgisi'] = kullanicibilgisi!.toJson();
    // }
    data['markaadi'] = markaAdi;
    data['isimsoyisim'] = isimsoyisim;
    data['yetki_Grubu'] = yetkiGrubu;
    data['ozelYetkiler'] = ozelYetkiler;
    return data;
  }
}

class Marka {
  late String db_user;
  late String db_name;
  late String adi;

  Marka.fromJson(Map<String, dynamic> json) {
    db_user = json['db_user'];
    db_name = json['db_name'];
    adi = json['marka_adi'];
  }
}

// class Kullanicibilgisi {
//   int? id;
//   String? isimsoyisim;
//   String? kullaniciadi;
//   String? eposta;
//   String? ulkekodu;
//   String? telefon;
//   String? sifre;
//   String? yetkiGrubu;
//   String? ozelYetkiler;
//   int? hesapdurumu;
//   String? sessions;
//   int? silinenleriGoster;
//   String? token;
//   String? tematercihleri;
//   String? magictoken;
//   String? olusturmaTarihi;
//   String? profilResmi;
//   String? tckimlikno;
//   String? cinsiyet;
//   String? uyeEvtel;
//   String? uyeAdres;
//   int? uyeIl;
//   int? uyeIlce;
//   String? misafirDurumu;
//   String? tesisler;
//   String? uyelikler;
//   String? odemeSekli;
//   String? kartId;
//   String? geciciQrkod;
//   String? medeniHali;
//   String? esAdi;
//   String? evlilikTarihi;
//   String? esDogumtarihi;
//   String? aileAdres;
//   String? aileIl;
//   String? aileIlce;
//   String? firmaAd;
//   String? firmaUnvan;
//   String? firmaCeptel;
//   String? firmaIstel;
//   String? firmaKimlik;
//   String? firmaEposta;
//   String? firmaAdres;
//   String? firmaIl;
//   String? firmaIlce;
//   String? webadres;
//   String? digerbilgiler;
//   String? uyeDogumyeri;
//   String? uyeDogumtarihi;
//   String? uyeEgitim;
//   String? uyeKangrubu;
//   String? aracplakasi;
//   String? uyeHobiler;
//   String? uyeFobiler;
//   String? acilAd1;
//   String? acilSoyad1;
//   String? acilTel1;
//   String? acilAd2;
//   String? acilSoyad2;
//   String? acilTel2;
//   String? acilAd3;
//   String? acilSoyad3;
//   String? acilTel3;
//   String? acilAd4;
//   String? acilSoyad4;
//   String? acilTel4;
//   String? acilAd5;
//   String? acilSoyad5;
//   String? acilTel5;
//   int? uyeDurumu;
//   String? detaylar;
//   String? yaptirimCezalari;
//   int? sifreDegistirildimi;
//   String? girisHakki;

//   Kullanicibilgisi(
//       {this.id,
//       this.isimsoyisim,
//       this.kullaniciadi,
//       this.eposta,
//       this.ulkekodu,
//       this.telefon,
//       this.sifre,
//       this.yetkiGrubu,
//       this.ozelYetkiler,
//       this.hesapdurumu,
//       this.sessions,
//       this.silinenleriGoster,
//       this.token,
//       this.tematercihleri,
//       this.magictoken,
//       this.olusturmaTarihi,
//       this.profilResmi,
//       this.tckimlikno,
//       this.cinsiyet,
//       this.uyeEvtel,
//       this.uyeAdres,
//       this.uyeIl,
//       this.uyeIlce,
//       this.misafirDurumu,
//       this.tesisler,
//       this.uyelikler,
//       this.odemeSekli,
//       this.kartId,
//       this.geciciQrkod,
//       this.medeniHali,
//       this.esAdi,
//       this.evlilikTarihi,
//       this.esDogumtarihi,
//       this.aileAdres,
//       this.aileIl,
//       this.aileIlce,
//       this.firmaAd,
//       this.firmaUnvan,
//       this.firmaCeptel,
//       this.firmaIstel,
//       this.firmaKimlik,
//       this.firmaEposta,
//       this.firmaAdres,
//       this.firmaIl,
//       this.firmaIlce,
//       this.webadres,
//       this.digerbilgiler,
//       this.uyeDogumyeri,
//       this.uyeDogumtarihi,
//       this.uyeEgitim,
//       this.uyeKangrubu,
//       this.aracplakasi,
//       this.uyeHobiler,
//       this.uyeFobiler,
//       this.acilAd1,
//       this.acilSoyad1,
//       this.acilTel1,
//       this.acilAd2,
//       this.acilSoyad2,
//       this.acilTel2,
//       this.acilAd3,
//       this.acilSoyad3,
//       this.acilTel3,
//       this.acilAd4,
//       this.acilSoyad4,
//       this.acilTel4,
//       this.acilAd5,
//       this.acilSoyad5,
//       this.acilTel5,
//       this.uyeDurumu,
//       this.detaylar,
//       this.yaptirimCezalari,
//       this.sifreDegistirildimi,
//       this.girisHakki});

//   Kullanicibilgisi.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     isimsoyisim = json['isimsoyisim'];
//     kullaniciadi = json['kullaniciadi'];
//     eposta = json['eposta'];
//     ulkekodu = json['ulkekodu'];
//     telefon = json['telefon'];
//     sifre = json['sifre'];
//     yetkiGrubu = json['yetki_Grubu'];
//     ozelYetkiler = json['ozelYetkiler'];
//     hesapdurumu = json['hesapdurumu'];
//     sessions = json['sessions'];
//     silinenleriGoster = json['silinenleriGoster'];
//     token = json['token'];
//     tematercihleri = json['tematercihleri'];
//     magictoken = json['magictoken'];
//     olusturmaTarihi = json['olusturma_tarihi'];
//     profilResmi = json['profil_resmi'];
//     tckimlikno = json['tckimlikno'];
//     cinsiyet = json['cinsiyet'];
//     uyeEvtel = json['uye_evtel'];
//     uyeAdres = json['uye_adres'];
//     uyeIl = json['uye_il'];
//     uyeIlce = json['uye_ilce'];
//     misafirDurumu = json['misafir_durumu'];
//     tesisler = json['tesisler'];
//     uyelikler = json['uyelikler'];
//     odemeSekli = json['odeme_sekli'];
//     kartId = json['kart_id'];
//     geciciQrkod = json['gecici_qrkod'];
//     medeniHali = json['medeni_hali'];
//     esAdi = json['es_adi'];
//     evlilikTarihi = json['evlilik_tarihi'];
//     esDogumtarihi = json['es_dogumtarihi'];
//     aileAdres = json['aile_adres'];
//     aileIl = json['aile_il'];
//     aileIlce = json['aile_ilce'];
//     firmaAd = json['firma_ad'];
//     firmaUnvan = json['firma_unvan'];
//     firmaCeptel = json['firma_ceptel'];
//     firmaIstel = json['firma_istel'];
//     firmaKimlik = json['firma_kimlik'];
//     firmaEposta = json['firma_eposta'];
//     firmaAdres = json['firma_adres'];
//     firmaIl = json['firma_il'];
//     firmaIlce = json['firma_ilce'];
//     webadres = json['webadres'];
//     digerbilgiler = json['digerbilgiler'];
//     uyeDogumyeri = json['uye_dogumyeri'];
//     uyeDogumtarihi = json['uye_dogumtarihi'];
//     uyeEgitim = json['uye_egitim'];
//     uyeKangrubu = json['uye_kangrubu'];
//     aracplakasi = json['aracplakasi'];
//     uyeHobiler = json['uye_hobiler'];
//     uyeFobiler = json['uye_fobiler'];
//     acilAd1 = json['acil_ad1'];
//     acilSoyad1 = json['acil_soyad1'];
//     acilTel1 = json['acil_tel1'];
//     acilAd2 = json['acil_ad2'];
//     acilSoyad2 = json['acil_soyad2'];
//     acilTel2 = json['acil_tel2'];
//     acilAd3 = json['acil_ad3'];
//     acilSoyad3 = json['acil_soyad3'];
//     acilTel3 = json['acil_tel3'];
//     acilAd4 = json['acil_ad4'];
//     acilSoyad4 = json['acil_soyad4'];
//     acilTel4 = json['acil_tel4'];
//     acilAd5 = json['acil_ad5'];
//     acilSoyad5 = json['acil_soyad5'];
//     acilTel5 = json['acil_tel5'];
//     uyeDurumu = json['uye_durumu'];
//     detaylar = json['detaylar'];
//     yaptirimCezalari = json['yaptirim_cezalari'];
//     sifreDegistirildimi = json['sifre_degistirildimi'];
//     girisHakki = json['giris_hakki'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['isimsoyisim'] = isimsoyisim;
//     data['kullaniciadi'] = kullaniciadi;
//     data['eposta'] = eposta;
//     data['ulkekodu'] = ulkekodu;
//     data['telefon'] = telefon;
//     data['sifre'] = sifre;
//     data['yetki_Grubu'] = yetkiGrubu;
//     data['ozelYetkiler'] = ozelYetkiler;
//     data['hesapdurumu'] = hesapdurumu;
//     data['sessions'] = sessions;
//     data['silinenleriGoster'] = silinenleriGoster;
//     data['token'] = token;
//     data['tematercihleri'] = tematercihleri;
//     data['magictoken'] = magictoken;
//     data['olusturma_tarihi'] = olusturmaTarihi;
//     data['profil_resmi'] = profilResmi;
//     data['tckimlikno'] = tckimlikno;
//     data['cinsiyet'] = cinsiyet;
//     data['uye_evtel'] = uyeEvtel;
//     data['uye_adres'] = uyeAdres;
//     data['uye_il'] = uyeIl;
//     data['uye_ilce'] = uyeIlce;
//     data['misafir_durumu'] = misafirDurumu;
//     data['tesisler'] = tesisler;
//     data['uyelikler'] = uyelikler;
//     data['odeme_sekli'] = odemeSekli;
//     data['kart_id'] = kartId;
//     data['gecici_qrkod'] = geciciQrkod;
//     data['medeni_hali'] = medeniHali;
//     data['es_adi'] = esAdi;
//     data['evlilik_tarihi'] = evlilikTarihi;
//     data['es_dogumtarihi'] = esDogumtarihi;
//     data['aile_adres'] = aileAdres;
//     data['aile_il'] = aileIl;
//     data['aile_ilce'] = aileIlce;
//     data['firma_ad'] = firmaAd;
//     data['firma_unvan'] = firmaUnvan;
//     data['firma_ceptel'] = firmaCeptel;
//     data['firma_istel'] = firmaIstel;
//     data['firma_kimlik'] = firmaKimlik;
//     data['firma_eposta'] = firmaEposta;
//     data['firma_adres'] = firmaAdres;
//     data['firma_il'] = firmaIl;
//     data['firma_ilce'] = firmaIlce;
//     data['webadres'] = webadres;
//     data['digerbilgiler'] = digerbilgiler;
//     data['uye_dogumyeri'] = uyeDogumyeri;
//     data['uye_dogumtarihi'] = uyeDogumtarihi;
//     data['uye_egitim'] = uyeEgitim;
//     data['uye_kangrubu'] = uyeKangrubu;
//     data['aracplakasi'] = aracplakasi;
//     data['uye_hobiler'] = uyeHobiler;
//     data['uye_fobiler'] = uyeFobiler;
//     data['acil_ad1'] = acilAd1;
//     data['acil_soyad1'] = acilSoyad1;
//     data['acil_tel1'] = acilTel1;
//     data['acil_ad2'] = acilAd2;
//     data['acil_soyad2'] = acilSoyad2;
//     data['acil_tel2'] = acilTel2;
//     data['acil_ad3'] = acilAd3;
//     data['acil_soyad3'] = acilSoyad3;
//     data['acil_tel3'] = acilTel3;
//     data['acil_ad4'] = acilAd4;
//     data['acil_soyad4'] = acilSoyad4;
//     data['acil_tel4'] = acilTel4;
//     data['acil_ad5'] = acilAd5;
//     data['acil_soyad5'] = acilSoyad5;
//     data['acil_tel5'] = acilTel5;
//     data['uye_durumu'] = uyeDurumu;
//     data['detaylar'] = detaylar;
//     data['yaptirim_cezalari'] = yaptirimCezalari;
//     data['sifre_degistirildimi'] = sifreDegistirildimi;
//     data['giris_hakki'] = girisHakki;
//     return data;
//   }
// }
