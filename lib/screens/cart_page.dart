import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../widgets/price_label.dart';
import 'checkout_page.dart';

/// Halaman Keranjang Belanja Riil (Pertemuan 6):
/// Menampilkan daftar item keranjang dengan Obx, tombol kuantitas, hapus item,
/// tombol kosongkan keranjang, total harga reaktif, dan navigasi ke Checkout via Get.to/Get.off.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        actions: [
          Obx(
            () => cartController.items.isNotEmpty
                ? TextButton.icon(
                    icon: const Icon(Icons.delete_sweep, color: Colors.red, size: 20),
                    label: const Text('Kosongkan', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Konfirmasi',
                        middleText: 'Apakah Anda yakin ingin mengosongkan seluruh isi keranjang?',
                        textConfirm: 'Ya, Kosongkan',
                        textCancel: 'Batal',
                        confirmTextColor: Colors.white,
                        buttonColor: Colors.red,
                        onConfirm: () {
                          cartController.clearCart();
                          Get.back(); // Tutup dialog
                        },
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text(
                  'Keranjang Belanja Anda Kosong',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Silakan jelajahi produk dan tambahkan ke sini.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          itemCount: cartController.items.length,
          itemBuilder: (context, index) {
            final cartItem = cartController.items[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon Kategori Thumbnail
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shopping_bag_outlined, color: Colors.deepPurple),
                  ),

                  const SizedBox(width: 12),

                  // Info Produk
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartItem.product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        PriceLabel(
                          price: cartItem.itemPrice,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.deepPurple.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Kontrol Kuantitas & Hapus
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 22, color: Colors.grey),
                        onPressed: () => cartController.decreaseQuantity(cartItem),
                      ),
                      Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 22, color: Colors.deepPurple),
                        onPressed: () => cartController.increaseQuantity(cartItem),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 22, color: Colors.red),
                        onPressed: () => cartController.removeFromCart(cartItem.product),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        if (cartController.items.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Pembayaran:',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    PriceLabel(
                      price: cartController.totalHarga,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Berpindah ke Halaman Checkout menggunakan Get.to atau Get.off
                    Get.to(() => const CheckoutPage());
                  },
                  child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}