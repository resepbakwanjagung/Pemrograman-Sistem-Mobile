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

  /// Factory constructor untuk memetakan JSON dari Fake Store API (Pertemuan 7)
  factory Product.fromJson(Map<String, dynamic> json) {
    // Fake Store API: id (int), title (String), price (num), description (String), category (String), image (String)
    // Konversi kurs USD Fake Store API ke estimasi IDR (x 15.000) agar selaras dengan format Rupiah TokoKita
    final rawPrice = json['price'];
    final double parsedPrice = rawPrice is num ? (rawPrice.toDouble() * 15000) : 0.0;

    // Nilai default stok (karena Fake Store API tidak menyertakan field stock, gunakan rating.count atau default 10)
    int parsedStock = 10;
    if (json['rating'] != null && json['rating']['count'] != null) {
      final count = json['rating']['count'];
      parsedStock = count is int ? (count % 20) : 10;
    }

    return Product(
      id: json['id'] != null ? json['id'].toString() : '',
      name: json['title'] as String? ?? 'Tanpa Nama',
      price: parsedPrice,
      imageUrl: json['image'] as String? ?? '',
      category: json['category'] as String? ?? 'Umum',
      stock: parsedStock,
      description: json['description'] as String?,
    );
  }

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
// DUMMY DATA UNTUK TOKOKITA (MINIMAL 15 PRODUK UNTUK PRAKTIKUM 4)
// -----------------------------------------------------------------------------
final List<Product> dummyProducts = [
  DiscountedProduct(
    id: 'P001',
    name: 'Smartphone TokoKita X1',
    price: 3500000.0,
    imageUrl: 'assets/images/phone.png',
    category: 'Elektronik',
    stock: 12,
    description: 'Smartphone canggih dengan layar AMOLED 120Hz.',
    discountPercent: 10.0,
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
  DiscountedProduct(
    id: 'P005',
    name: 'Keripik Pisang Lumer 250g',
    price: 25000.0,
    imageUrl: 'assets/images/keripik.png',
    category: 'Makanan',
    stock: 100,
    description: 'Camilan pisang dengan varian rasa cokelat lumer.',
    discountPercent: 5.0,
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
  DiscountedProduct(
    id: 'P007',
    name: 'Headphone Wireless BassBoost',
    price: 450000.0,
    imageUrl: 'assets/images/headphone.png',
    category: 'Elektronik',
    stock: 15,
    description: 'Headphone Bluetooth dengan daya tahan baterai 30 jam.',
    discountPercent: 15.0,
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
  Product(
    id: 'P009',
    name: 'Smartwatch Active Pro',
    price: 890000.0,
    imageUrl: 'assets/images/smartwatch.png',
    category: 'Elektronik',
    stock: 8,
    description: 'Jam tangan pintar dengan pemantau detak jantung dan SpO2.',
  ),
  DiscountedProduct(
    id: 'P010',
    name: 'Kemeja Flannel Tartan',
    price: 195000.0,
    imageUrl: 'assets/images/flannel.png',
    category: 'Fashion',
    stock: 18,
    description: 'Kemeja flannel motif kotak katun premium.',
    discountPercent: 20.0,
  ),
  Product(
    id: 'P011',
    name: 'Roti Gandum Whole Wheat',
    price: 22000.0,
    imageUrl: 'assets/images/bread.png',
    category: 'Makanan',
    stock: 5, // Stok terbatas
    description: 'Roti tawar gandum tinggi serat sehat.',
  ),
  Product(
    id: 'P012',
    name: 'Mouse Wireless Silent Click',
    price: 135000.0,
    imageUrl: 'assets/images/mouse.png',
    category: 'Elektronik',
    stock: 0, // Stok habis
    description: 'Mouse ergonomis tanpa suara klik.',
  ),
  DiscountedProduct(
    id: 'P013',
    name: 'Tas Ransel Laptop Waterproof',
    price: 320000.0,
    imageUrl: 'assets/images/backpack.png',
    category: 'Fashion',
    stock: 14,
    description: 'Ransel kapasitas 20L dengan kompartemen laptop 15.6 inch.',
    discountPercent: 12.0,
  ),
  Product(
    id: 'P014',
    name: 'Cokelat Batang Dark 70%',
    price: 38000.0,
    imageUrl: 'assets/images/chocolate.png',
    category: 'Makanan',
    stock: 25,
    description: 'Cokelat hitam murni dengan rasa intens.',
  ),
  DiscountedProduct(
    id: 'P015',
    name: 'Keyboard Mechanical RGB',
    price: 650000.0,
    imageUrl: 'assets/images/keyboard.png',
    category: 'Elektronik',
    stock: 7,
    description: 'Keyboard mechanical blue switch dengan lampu RGB.',
    discountPercent: 25.0,
  ),
  Product(
    id: 'P016',
    name: 'Celana Chino Slim Fit',
    price: 210000.0,
    imageUrl: 'assets/images/chino.png',
    category: 'Fashion',
    stock: 10,
    description: 'Celana panjang chino bahan stretch kasual.',
  ),
];
