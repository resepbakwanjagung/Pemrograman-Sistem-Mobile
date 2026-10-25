import 'package:get/get.dart';
import '../models/product.dart';

/// Model item keranjang belanja yang mengikat Product dengan kuantitasnya
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get itemPrice {
    if (product is DiscountedProduct) {
      return (product as DiscountedProduct).hitungHargaFinal();
    }
    return product.price;
  }

  double get subtotal => itemPrice * quantity;
}

/// CartController (Pertemuan 6):
/// Mengelola state keranjang secara reaktif menggunakan GetX.
class CartController extends GetxController {
  // Daftar item keranjang reaktif
  final RxList<CartItem> items = <CartItem>[].obs;

  /// Total seluruh item/kuantitas barang di keranjang
  int get totalItem => items.fold(0, (sum, item) => sum + item.quantity);

  /// Total harga seluruh barang di keranjang
  double get totalHarga => items.fold(0.0, (sum, item) => sum + item.subtotal);

  /// Menambahkan produk ke keranjang
  void addToCart(Product product, {int quantity = 1}) {
    final index = items.indexWhere((element) => element.product.id == product.id);
    if (index >= 0) {
      // Jika produk sudah ada, tingkatkan kuantitasnya
      items[index].quantity += quantity;
      items.refresh();
    } else {
      items.add(CartItem(product: product, quantity: quantity));
    }
  }

  /// Menambah kuantitas item di keranjang
  void increaseQuantity(CartItem item) {
    if (item.quantity < item.product.stock) {
      item.quantity++;
      items.refresh();
    } else {
      Get.snackbar(
        'Stok Maksimal',
        'Jumlah telah mencapai stok maksimal yang tersedia.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Mengurangi kuantitas item di keranjang
  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      items.refresh();
    } else {
      removeFromCart(item.product);
    }
  }

  /// Menghapus produk dari keranjang
  void removeFromCart(Product product) {
    items.removeWhere((element) => element.product.id == product.id);
  }

  /// Mengosongkan seluruh isi keranjang belanja
  void clearCart() {
    items.clear();
  }
}