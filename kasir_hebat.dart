import 'dart:io';

void main() {
  // Katalog produk
  Map<String, Map<String, dynamic>> katalog = {
    "M001": {
      "nama": "Air Mineral",
      "harga": 5000,
      "stok": 50,
      "kategori": "minuman",
    },
    "M002": {
      "nama": "Jus Jeruk",
      "harga": 12000,
      "stok": 30,
      "kategori": "minuman",
    },
    "M003": {
      "nama": "Kopi Kaleng",
      "harga": 15000,
      "stok": 25,
      "kategori": "minuman",
    },
    "S001": {
      "nama": "Keripik Kentang",
      "harga": 12000,
      "stok": 40,
      "kategori": "snack",
    },
    "S002": {
      "nama": "Coklat Batang",
      "harga": 8000,
      "stok": 35,
      "kategori": "snack",
    },
    "S003": {
      "nama": "Kacang Almond",
      "harga": 25000,
      "stok": 20,
      "kategori": "snack",
    },
    "L001": {
      "nama": "Sabun Mandi",
      "harga": 7000,
      "stok": 60,
      "kategori": "lainnya",
    },
  };

  // Keranjang belanja pelanggan
  Map<String, int> keranjang = {
    "M001": 8, // Minuman, qty besar untuk promo
    "S002": 3,
    "S003": 4, // Snack dengan harga tinggi
    "L001": 2,
    "X999": 5, // Kode tidak ada (untuk testing)
  };

  stdout.write('Apakah pelanggan member? (true/false): ');
  bool isMember = stdin.readLineSync()?.toLowerCase() == 'true';

  print('\n=== PROSES TRANSAKSI HEMART ===');

  // Variabel untuk perhitungan
  Map<String, double> subtotalPerKategori = {
    'minuman': 0.0,
    'snack': 0.0,
    'lainnya': 0.0,
  };

  double totalBelanja = 0.0;
  Map<String, Map<String, dynamic>> detailItem = {};

  // Loop untuk memproses setiap item di keranjang
  keranjang.forEach((kode, qtyDiminta) {
    print('\nMemproses: $kode (Qty: $qtyDiminta)');

    if (katalog.containsKey(kode)) {
      var produk = katalog[kode]!;
      int stokTersedia = produk['stok'];
      String kategori = produk['kategori'];

      if (qtyDiminta <= stokTersedia) {
        int qtyDitagih = qtyDiminta;

        // Promo "beli 5 gratis 1" untuk minuman
        if (kategori == "minuman" && qtyDiminta >= 6) {
          int gratis = (qtyDiminta / 6).floor();
          qtyDitagih = qtyDiminta - gratis;
          print('  Promo: beli 5 gratis 1 -> Qty ditagih: $qtyDitagih');
        }

        double subtotal = qtyDitagih * (produk['harga'] as int).toDouble();
        subtotalPerKategori[kategori] =
            subtotalPerKategori[kategori]! + subtotal;
        totalBelanja += subtotal;

        // Simpan detail untuk struk
        detailItem[kode] = {
          'nama': produk['nama'],
          'qtyDiminta': qtyDiminta,
          'qtyDitagih': qtyDitagih,
          'harga': produk['harga'],
          'subtotal': subtotal,
          'kategori': kategori,
        };

        // Update stok di katalog
        produk['stok'] =
            stokTersedia - qtyDiminta; // Berkurang sesuai permintaan
        print('  ✓ Berhasil: $qtyDitagih item ditagih');
      } else {
        print('  ✗ Ditolak: Stok tidak cukup (tersedia: $stokTersedia)');
      }
    } else {
      print('  ✗ Ditolak: Kode barang tidak ditemukan');
    }
  });

  // Diskon snack jika subtotal snack > 50.000
  double diskonSnack = 0.0;
  if (subtotalPerKategori['snack']! > 50000) {
    diskonSnack = subtotalPerKategori['snack']! * 0.10;
    totalBelanja -= diskonSnack;
    print('\n✓ Diskon snack 10%: Rp ${diskonSnack.toStringAsFixed(0)}');
  }

  // Benefit tambahan berdasarkan total belanja
  double diskonTambahan = 0.0;
  String benefit = "";
  if (totalBelanja > 150000) {
    if (isMember) {
      diskonTambahan = totalBelanja * 0.05;
      totalBelanja -= diskonTambahan;
      benefit = "Diskon member 5%: Rp ${diskonTambahan.toStringAsFixed(0)}";
    } else if (totalBelanja > 200000) {
      benefit = "Voucher belanja Rp 10.000 untuk kunjungan berikutnya";
    }
  }

  // Tampilkan struk
  print('\n=== STRUK PEMBAYARAN HEMART ===');
  detailItem.forEach((kode, detail) {
    print('${detail['nama']}:');
    print(
      '  Qty: ${detail['qtyDiminta']} diminta / ${detail['qtyDitagih']} ditagih',
    );
    print('  Subtotal: Rp ${detail['subtotal'].toStringAsFixed(0)}');
  });

  print('\n--- RINGKASAN ---');
  if (diskonSnack > 0)
    print('Diskon kategori snack: Rp ${diskonSnack.toStringAsFixed(0)}');
  if (benefit.isNotEmpty) print('Benefit: $benefit');
  print('TOTAL AKHIR: Rp ${totalBelanja.toStringAsFixed(0)}');

  print('\n--- KATALOG TERUPDATE ---');
  katalog.forEach((kode, produk) {
    print(
      '$kode: ${produk['nama']} - Stok: ${produk['stok']} - Rp ${produk['harga']}',
    );
  });
}
