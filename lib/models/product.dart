// lib/models/product.dart
// Model data utama untuk aplikasi TokoKita (Pertemuan 2)

/// Nama Toko dijadikan const karena nilainya konstan pada tingkat kompilasi
const String namaToko = 'TokoKita Official';

/// Class Product merepresentasikan entitas data produk pada TokoKita
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final int stock;
  final String? description; // Nullable property

  /// Constructor dengan named required & optional parameter
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    this.description,
  });

  /// Status ketersediaan produk (getter/method)
  bool get isAvailable => stock > 0;

  /// Method Tugas Mandiri 1: Mengembalikan status stok berdasarkan jumlahnya
  String getStatusStok() {
    if (stock <= 0) {
      return 'Habis';
    } else if (stock <= 5) {
      return 'Stok Terbatas';
    } else {
      return 'Tersedia';
    }
  }

  /// Format harga ke format Rupiah sederhana menggunakan arrow function
  String get formattedPrice => 'Rp ${price.toStringAsFixed(0)}';

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $formattedPrice, stock: $stock, category: $category, status: ${getStatusStok()})';
  }
}

/// Class DiscountedProduct mendemonstrasikan Inheritance (Turunan dari Product)
class DiscountedProduct extends Product {
  final double discountPercent; // e.g., 10.0 for 10%

  DiscountedProduct({
    required super.id,
    required super.name,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.stock,
    super.description,
    required this.discountPercent,
  });

  /// Method untuk menghitung harga final setelah diskon
  double hitungHargaFinal() {
    return price * (1 - (discountPercent / 100));
  }

  /// Format harga final ke Rupiah
  String get formattedFinalPrice => 'Rp ${hitungHargaFinal().toStringAsFixed(0)}';

  @override
  String toString() {
    return 'DiscountedProduct(name: $name, originalPrice: $formattedPrice, discount: $discountPercent%, finalPrice: $formattedFinalPrice)';
  }
}

// -----------------------------------------------------------------------------
// LOGIKA & FUNCTION TAMBAHAN (LANGKAH 2, 3, 4 & TUGAS MANDIRI)
// -----------------------------------------------------------------------------

/// Arrow function untuk format angka Rupiah
String formatRupiah(double nominal) => 'Rp ${nominal.toStringAsFixed(0)}';

/// Function dengan named & optional parameter untuk menghitung harga setelah diskon
double hitungHargaSetelahDiskon(double harga, {double persenDiskon = 0.0}) {
  if (persenDiskon < 0 || persenDiskon > 100) return harga;
  return harga - (harga * (persenDiskon / 100));
}

/// Switch-case untuk menentukan besaran diskon berdasarkan kategori produk
double getDiskonKategori(String category) {
  switch (category.toLowerCase()) {
    case 'elektronik':
      return 10.0;
    case 'fashion':
      return 15.0;
    case 'makanan':
      return 5.0;
    default:
      return 0.0;
  }
}

/// Function Tugas Mandiri 3: Menghitung total belanja dari sekumpulan produk (List<Product>)
double hitungTotalBelanja(List<Product> keranjang) {
  double total = 0.0;
  for (var produk in keranjang) {
    total += produk.price;
  }
  return total;
}

// -----------------------------------------------------------------------------
// DUMMY DATA UNTUK TOKOKITA (TUGAS MANDIRI 2: MINIMAL 8 PRODUK)
// -----------------------------------------------------------------------------
final List<Product> dummyProducts = [
  Product(
    id: 'P001',
    name: 'Smartphone TokoKita X1',
    price: 3500000.0,
    imageUrl: 'assets/images/phone.png',
    category: 'Elektronik',
    stock: 12,
    description: 'Smartphone canggih dengan layar AMOLED 120Hz.',
  ),
  Product(
    id: 'P002',
    name: 'Laptop Pro 14 Inch',
    price: 12500000.0,
    imageUrl: 'assets/images/laptop.png',
    category: 'Elektronik',
    stock: 3, // Stok terbatas
    description: 'Laptop performa tinggi untuk pengembang software.',
  ),
  Product(
    id: 'P003',
    name: 'T-Shirt Cotton Combed 30s',
    price: 85000.0,
    imageUrl: 'assets/images/tshirt.png',
    category: 'Fashion',
    stock: 50,
    description: 'Kaos bahan adem dan nyaman dipakai sehari-hari.',
  ),
  Product(
    id: 'P004',
    name: 'Jaket Denim Casual',
    price: 275000.0,
    imageUrl: 'assets/images/jacket.png',
    category: 'Fashion',
    stock: 0, // Stok habis
    description: null, // Nullable test
  ),
  Product(
    id: 'P005',
    name: 'Keripik Pisang Lumer 250g',
    price: 25000.0,
    imageUrl: 'assets/images/keripik.png',
    category: 'Makanan',
    stock: 100,
    description: 'Camilan pisang dengan varian rasa cokelat lumer.',
  ),
  Product(
    id: 'P006',
    name: 'Kopi Kenangan Mantan 1L',
    price: 65000.0,
    imageUrl: 'assets/images/kopi.png',
    category: 'Makanan',
    stock: 4, // Stok terbatas
    description: 'Kopi susu gula aren botol 1 liter.',
  ),
  Product(
    id: 'P007',
    name: 'Headphone Wireless BassBoost',
    price: 450000.0,
    imageUrl: 'assets/images/headphone.png',
    category: 'Elektronik',
    stock: 15,
    description: 'Headphone Bluetooth dengan daya tahan baterai 30 jam.',
  ),
  Product(
    id: 'P008',
    name: 'Sepatu Sneaker Off-White',
    price: 520000.0,
    imageUrl: 'assets/images/sneakers.png',
    category: 'Fashion',
    stock: 2, // Stok terbatas
    description: 'Sepatu kets stylish untuk gaya kasual.',
  ),
];
