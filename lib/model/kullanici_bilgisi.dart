class Kullanicibilgisi {
  int? id;
  String? isimsoyisim;
  String? kullaniciadi;
  String? eposta;
  String? ulkekodu;
  String? telefon;
  String? sifre;
  String? yetkiGrubu;
  String? ozelYetkiler;
  int? hesapdurumu;
  String? sessions;
  int? silinenleriGoster;
  
  String? magictoken;
  
  
  
  String? cinsiyet;
  
  
  int? uyeIl;
  int? uyeIlce;
  String? misafirDurumu;
  String? tesisler;
  String? uyelikler;
  String? odemeSekli;
  String? kartId;
  String? geciciQrkod;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  int? uyeDurumu;
  
  String? yaptirimCezalari;
  int? sifreDegistirildimi;
  String? girisHakki;

  Kullanicibilgisi(
      {this.id,
      this.isimsoyisim,
      this.kullaniciadi,
      this.eposta,
      this.ulkekodu,
      this.telefon,
      this.sifre,
      this.yetkiGrubu,
      this.ozelYetkiler,
      this.hesapdurumu,
      this.sessions,
      this.silinenleriGoster,
      this.magictoken,
      this.cinsiyet,
      this.uyeIl,
      this.uyeIlce,
      this.misafirDurumu,
      this.tesisler,
      this.uyelikler,
      this.odemeSekli,
      this.kartId,
      this.geciciQrkod,
      this.uyeDurumu,
     this.yaptirimCezalari,
      this.sifreDegistirildimi,
      this.girisHakki});

  Kullanicibilgisi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isimsoyisim = json['isimsoyisim'];
    kullaniciadi = json['kullaniciadi'];
    eposta = json['eposta'];
    ulkekodu = json['ulkekodu'];
    telefon = json['telefon'];
    sifre = json['sifre'];
    yetkiGrubu = json['yetki_Grubu'];
    ozelYetkiler = json['ozelYetkiler'];
    hesapdurumu = json['hesapdurumu'];
    sessions = json['sessions'];
    silinenleriGoster = json['silinenleriGoster'];
    magictoken = json['magictoken'];
     cinsiyet = json['cinsiyet'];
     uyeIl = json['uye_il'];
    uyeIlce = json['uye_ilce'];
    misafirDurumu = json['misafir_durumu'];
    tesisler = json['tesisler'];
    uyelikler = json['uyelikler'];
    odemeSekli = json['odeme_sekli'];
    kartId = json['kart_id'];
    geciciQrkod = json['gecici_qrkod'];
    uyeDurumu = json['uye_durumu'];
    yaptirimCezalari = json['yaptirim_cezalari'];
    sifreDegistirildimi = json['sifre_degistirildimi'];
    girisHakki = json['giris_hakki'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['isimsoyisim'] = this.isimsoyisim;
  //   data['kullaniciadi'] = this.kullaniciadi;
  //   data['eposta'] = this.eposta;
  //   data['ulkekodu'] = this.ulkekodu;
  //   data['telefon'] = this.telefon;
  //   data['sifre'] = this.sifre;
  //   data['yetki_Grubu'] = this.yetkiGrubu;
  //   data['ozelYetkiler'] = this.ozelYetkiler;
  //   data['hesapdurumu'] = this.hesapdurumu;
  //   data['sessions'] = this.sessions;
  //   data['silinenleriGoster'] = this.silinenleriGoster;
  //   data['token'] = this.token;
  //   data['tematercihleri'] = this.tematercihleri;
  //   data['magictoken'] = this.magictoken;
  //   data['olusturma_tarihi'] = this.olusturmaTarihi;
  //   data['profil_resmi'] = this.profilResmi;
  //   data['tckimlikno'] = this.tckimlikno;
  //   data['cinsiyet'] = this.cinsiyet;
  //   data['uye_evtel'] = this.uyeEvtel;
  //   data['uye_adres'] = this.uyeAdres;
  //   data['uye_il'] = this.uyeIl;
  //   data['uye_ilce'] = this.uyeIlce;
  //   data['misafir_durumu'] = this.misafirDurumu;
  //   data['tesisler'] = this.tesisler;
  //   data['uyelikler'] = this.uyelikler;
  //   data['odeme_sekli'] = this.odemeSekli;
  //   data['kart_id'] = this.kartId;
  //   data['gecici_qrkod'] = this.geciciQrkod;
  //   data['medeni_hali'] = this.medeniHali;
  //   data['es_adi'] = this.esAdi;
  //   data['evlilik_tarihi'] = this.evlilikTarihi;
  //   data['es_dogumtarihi'] = this.esDogumtarihi;
  //   data['aile_adres'] = this.aileAdres;
  //   data['aile_il'] = this.aileIl;
  //   data['aile_ilce'] = this.aileIlce;
  //   data['firma_ad'] = this.firmaAd;
  //   data['firma_unvan'] = this.firmaUnvan;
  //   data['firma_ceptel'] = this.firmaCeptel;
  //   data['firma_istel'] = this.firmaIstel;
  //   data['firma_kimlik'] = this.firmaKimlik;
  //   data['firma_eposta'] = this.firmaEposta;
  //   data['firma_adres'] = this.firmaAdres;
  //   data['firma_il'] = this.firmaIl;
  //   data['firma_ilce'] = this.firmaIlce;
  //   data['webadres'] = this.webadres;
  //   data['digerbilgiler'] = this.digerbilgiler;
  //   data['uye_dogumyeri'] = this.uyeDogumyeri;
  //   data['uye_dogumtarihi'] = this.uyeDogumtarihi;
  //   data['uye_egitim'] = this.uyeEgitim;
  //   data['uye_kangrubu'] = this.uyeKangrubu;
  //   data['aracplakasi'] = this.aracplakasi;
  //   data['uye_hobiler'] = this.uyeHobiler;
  //   data['uye_fobiler'] = this.uyeFobiler;
  //   data['acil_ad1'] = this.acilAd1;
  //   data['acil_soyad1'] = this.acilSoyad1;
  //   data['acil_tel1'] = this.acilTel1;
  //   data['acil_ad2'] = this.acilAd2;
  //   data['acil_soyad2'] = this.acilSoyad2;
  //   data['acil_tel2'] = this.acilTel2;
  //   data['acil_ad3'] = this.acilAd3;
  //   data['acil_soyad3'] = this.acilSoyad3;
  //   data['acil_tel3'] = this.acilTel3;
  //   data['acil_ad4'] = this.acilAd4;
  //   data['acil_soyad4'] = this.acilSoyad4;
  //   data['acil_tel4'] = this.acilTel4;
  //   data['acil_ad5'] = this.acilAd5;
  //   data['acil_soyad5'] = this.acilSoyad5;
  //   data['acil_tel5'] = this.acilTel5;
  //   data['uye_durumu'] = this.uyeDurumu;
  //   data['detaylar'] = this.detaylar;
  //   data['yaptirim_cezalari'] = this.yaptirimCezalari;
  //   data['sifre_degistirildimi'] = this.sifreDegistirildimi;
  //   data['giris_hakki'] = this.girisHakki;
  //   return data;
  // }
}
