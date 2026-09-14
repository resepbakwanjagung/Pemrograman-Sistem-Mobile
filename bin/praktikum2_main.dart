// bin/praktikum2_main.dart
// Program pengujian Praktikum 2 - Pemrograman Mobile (Dasar Dart & TokoKita)

import '../lib/models/product.dart';

void main() {
  print('====================================================');
  print('       PRAKTIKUM 2 - PEMROGRAMAN MOBILE (DART)     ');
  print('                TOKO KITA OFFICIAL                 ');
  print('====================================================\n');

  // ---------------------------------------------------------------------------
  // LANGKAH 1: Variabel & Tipe Data untuk Data Produk
  // ---------------------------------------------------------------------------
  print('--- LANGKAH 1: Variabel & Tipe Data Data Produk ---');
  print('Const Nama Toko : $namaToko');
  
  var namaProdukVar = 'Mouse Gaming RGB';
  final DateTime tanggalDibuat = DateTime.now();
  print('Var Nama Produk : $namaProdukVar');
  print('Final Tanggal   : $tanggalDibuat');

  int stok = 15;
  double harga = 150000.0;
  String namaProduk = 'Keyboard Mechanical';
  bool statusTersedia = stok > 0;

  print('Data Produk : $namaProduk | Tipe String');
  print('Harga       : $harga | Tipe double');
  print('Stok        : $stok | Tipe int');
  print('Tersedia    : $statusTersedia | Tipe bool');

  List<String> kategoriList = ['Elektronik', 'Fashion', 'Makanan', 'Aksesoris'];
  print('List Kategori: $kategoriList');

  Map<String, dynamic> rawProduct = {
    'id': 'RAW001',
    'name': 'Powerbank 10000mAh',
    'price': 199000.0,
    'stock': 20,
    'category': 'Elektronik',
    'isAvailable': true,
  };
  print('Map Data Mentah Produk: $rawProduct\n');

  // ---------------------------------------------------------------------------
  // LANGKAH 2: Operator untuk Perhitungan Harga & Stok
  // ---------------------------------------------------------------------------
  print('--- LANGKAH 2: Operator Aritmatika, Perbandingan & Logika ---');
  int jumlahBeli = 3;
  double totalHargaPembelian = harga * jumlahBeli;
  int sisaStok = stok - jumlahBeli;
  print('Hitung Total Beli ($jumlahBeli item): $harga * $jumlahBeli = ${formatRupiah(totalHargaPembelian)}');
  print('Hitung Sisa Stok                  : $stok - $jumlahBeli = $sisaStok');

  double hargaProdukA = 150000.0;
  double hargaProdukB = 250000.0;
  print('Perbandingan Harga: Produk A (${formatRupiah(hargaProdukA)}) < Produk B (${formatRupiah(hargaProdukB)}) -> ${hargaProdukA < hargaProdukB}');

  bool layakTampil = (stok > 0) && (harga > 0);
  print('Operator Logika Layak Tampil (stok > 0 && harga > 0): $layakTampil\n');

  // ---------------------------------------------------------------------------
  // LANGKAH 3: Control Flow untuk Logika Toko
  // ---------------------------------------------------------------------------
  print('--- LANGKAH 3: Control Flow (if-else, for, while, switch) ---');
  print('Testing Status Stok dengan if-else:');
  for (var sampleStok in [0, 3, 10]) {
    String labelStatus;
    if (sampleStok <= 0) {
      labelStatus = 'Habis';
    } else if (sampleStok <= 5) {
      labelStatus = 'Stok Terbatas';
    } else {
      labelStatus = 'Tersedia';
    }
    print('  - Jumlah Stok = $sampleStok -> Status: $labelStatus');
  }

  List<double> hargaBeberapaProduk = [150000.0, 85000.0, 25000.0, 450000.0];
  double totalFor = 0.0;
  for (int i = 0; i < hargaBeberapaProduk.length; i++) {
    totalFor += hargaBeberapaProduk[i];
  }
  print('Perulangan for (Total Belanja List Harga): ${formatRupiah(totalFor)}');

  int simulasiStok = 5;
  print('Perulangan while (Simulasi Pengurangan Stok):');
  while (simulasiStok > 0) {
    print('  Stok tersisa: $simulasiStok -> Item dibeli 1');
    simulasiStok--;
  }
  print('  Stok akhir: $simulasiStok (Stok Habis)');

  print('Switch-case Diskon Kategori:');
  for (var cat in ['Elektronik', 'Fashion', 'Makanan', 'Lainnya']) {
    print('  - Kategori: $cat -> Diskon: ${getDiskonKategori(cat)}%');
  }
  print('');

  // ---------------------------------------------------------------------------
  // LANGKAH 4: Function untuk Logika Produk & Diskon
  // ---------------------------------------------------------------------------
  print('--- LANGKAH 4: Function & Parameter (Named, Optional, Arrow) ---');
  double hargaAwal = 500000.0;
  double hargaSetelahDiskonDefault = hitungHargaSetelahDiskon(hargaAwal);
  double hargaSetelahDiskonCustom = hitungHargaSetelahDiskon(hargaAwal, persenDiskon: 20.0);

  print('Harga Awal                        : ${formatRupiah(hargaAwal)}');
  print('Harga Diskon Default (0%)          : ${formatRupiah(hargaSetelahDiskonDefault)}');
  print('Harga Diskon Named Param (20%)     : ${formatRupiah(hargaSetelahDiskonCustom)}');
  print('Arrow Function formatRupiah(125000): ${formatRupiah(125000.0)}\n');

  // ---------------------------------------------------------------------------
  // LANGKAH 5: Class Product, Inheritance & Null Safety
  // ---------------------------------------------------------------------------
  print('--- LANGKAH 5: Class Product, Inheritance & Null Safety ---');
  Product prod1 = Product(
    id: 'P100',
    name: 'Headset Gaming Stereo',
    price: 350000.0,
    imageUrl: 'assets/headset.png',
    category: 'Elektronik',
    stock: 8,
    description: 'Headset nyaman untuk gaming lama.',
  );
  print('Instance Product: $prod1');

  DiscountedProduct discProd = DiscountedProduct(
    id: 'P101',
    name: 'Smartwatch TokoKita Fit',
    price: 800000.0,
    imageUrl: 'assets/watch.png',
    category: 'Elektronik',
    stock: 10,
    description: null,
    discountPercent: 15.0,
  );
  print('Instance DiscountedProduct (Inheritance): $discProd');
  print('Deskripsi Null Safety Check (String?): ${discProd.description ?? "Deskripsi tidak tersedia"}\n');

  // ---------------------------------------------------------------------------
  // TUGAS MANDIRI 1, 2, 3
  // ---------------------------------------------------------------------------
  print('====================================================');
  print('                 TUGAS MANDIRI                      ');
  print('====================================================');
  print('1. Method getStatusStok() pada Class Product:');
  for (var p in dummyProducts.take(4)) {
    print('   - ${p.name} (Stok: ${p.stock}) -> Status: ${p.getStatusStok()}');
  }

  print('\n2. List<Product> Dummy Data TokoKita (Total ${dummyProducts.length} Produk):');
  for (var i = 0; i < dummyProducts.length; i++) {
    var p = dummyProducts[i];
    print('   [${i + 1}] ${p.id} | ${p.name.padRight(28)} | ${p.formattedPrice.padRight(14)} | Stok: ${p.stock.toString().padRight(3)} | ${p.getStatusStok()}');
  }

  print('\n3. Function hitungTotalBelanja(List<Product> keranjang):');
  List<Product> keranjangSimulasi = [dummyProducts[0], dummyProducts[2], dummyProducts[4]];
  print('   Item dalam keranjang:');
  for (var item in keranjangSimulasi) {
    print('     - ${item.name} (${item.formattedPrice})');
  }
  double totalBelanjaKeranjang = hitungTotalBelanja(keranjangSimulasi);
  print('   TOTAL BELANJA KERANJANG = ${formatRupiah(totalBelanjaKeranjang)}');

  print('\n====================================================');
  print('  PENGUJIAN SELESAI & SELURUH LOGIKA BERHASIL VALIDATED ');
  print('====================================================');
}
