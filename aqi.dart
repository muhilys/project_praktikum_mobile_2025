import 'dart:io';

void main() {
  // Data AQI mingguan (Senin - Minggu)
  List<int> aqiMingguan = [45, 65, 120, 80, 160, 55, 70];

  // Data acara luar ruang
  List<bool> acaraLuarRuang = [true, false, true, true, false, true, false];

  // Nama hari
  List<String> namaHari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  // Variabel untuk ringkasan menggunakan Map
  Map<String, int> jumlahHariPerKategori = {
    'Baik': 0,
    'Sedang': 0,
    'Tidak Sehat bagi Kelompok Sensitif': 0,
    'Tidak Sehat': 0,
  };

  int totalAQI = 0;
  int streakBaikSaatIni = 0;
  int streakBaikTerpanjang = 0;

  print('=== LAPORAN AQI MINGGUAN KOTA SEHATJAYA ===\n');

  // Loop untuk memproses setiap hari
  for (int i = 0; i < aqiMingguan.length; i++) {
    int aqi = aqiMingguan[i];
    String hari = namaHari[i];
    bool isAkhirPekan = (hari == 'Sabtu' || hari == 'Minggu');

    totalAQI += aqi;

    // Logika penentuan kategori
    String kategori;
    String rekomendasi = "";

    if (aqi <= 50) {
      kategori = "Baik";
      jumlahHariPerKategori['Baik'] = jumlahHariPerKategori['Baik']! + 1;
      streakBaikSaatIni++;
      if (streakBaikSaatIni > streakBaikTerpanjang) {
        streakBaikTerpanjang = streakBaikSaatIni;
      }
    } else {
      streakBaikSaatIni = 0; // Reset streak jika tidak kategori Baik

      if (aqi >= 51 && aqi <= 100) {
        kategori = "Sedang";
        jumlahHariPerKategori['Sedang'] = jumlahHariPerKategori['Sedang']! + 1;

        if (acaraLuarRuang[i]) {
          rekomendasi = "Masker dianjurkan";
        }
      } else if (aqi >= 101 && aqi <= 150) {
        kategori = "Tidak Sehat bagi Kelompok Sensitif";
        jumlahHariPerKategori['Tidak Sehat bagi Kelompok Sensitif'] =
            jumlahHariPerKategori['Tidak Sehat bagi Kelompok Sensitif']! + 1;
      } else {
        kategori = "Tidak Sehat";
        jumlahHariPerKategori['Tidak Sehat'] =
            jumlahHariPerKategori['Tidak Sehat']! + 1;

        if (isAkhirPekan) {
          rekomendasi = "Pertimbangkan tetap di rumah";
        }
      }
    }

    // Tampilkan laporan harian
    print('$hari:');
    print('  AQI: $aqi');
    print('  Kategori: $kategori');
    if (rekomendasi.isNotEmpty) {
      print('  Rekomendasi: $rekomendasi');
    }
    print('');
  }

  // Hitung rata-rata
  double rataRataAQI = totalAQI / aqiMingguan.length;

  // Tampilkan ringkasan mingguan
  print('=== RINGKASAN MINGGUAN ===');
  print('Jumlah hari per kategori:');
  jumlahHariPerKategori.forEach((kategori, jumlah) {
    print('  $kategori: $jumlah hari');
  });

  print('\nRata-rata AQI mingguan: ${rataRataAQI.toStringAsFixed(1)}');
  print('Streak hari "Baik" terpanjang: $streakBaikTerpanjang hari');
}
