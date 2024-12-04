


class MarkaHelper {
  static String? seciliMarkaAdi;

  // Seçilen markayı ayarlamak için kullanılan metod
  static void setMarka(String markaAdi) => seciliMarkaAdi = markaAdi;

  // Seçilen markayı almak için kullanılan metod
  static String? getMarka() => seciliMarkaAdi;

  // Seçilen markayı kaldırmak için kullanılan metod
  static void removeMarka() => seciliMarkaAdi = null;
}
