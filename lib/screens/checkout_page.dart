import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../widgets/price_label.dart';

/// Halaman Checkout Sederhana (Tugas Mandiri Pertemuan 6):
/// Menampilkan ringkasan pesanan dan total pembayaran,
/// serta menggunakan Get.offAllNamed('/') untuk kembali ke Beranda setelah checkout berhasil.
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: cartController.items.isEmpty
          ? const Center(child: Text('Tidak ada produk yang di-checkout'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Barang',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: cartController.items.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = cartController.items[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${item.quantity} x Rp ${item.itemPrice.toStringAsFixed(0)}',
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            PriceLabel(price: item.subtotal),
                          ],
                        );
                      },
                    ),
                  ),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Tagihan:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      PriceLabel(
                        price: cartController.totalHarga,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Kosongkan keranjang setelah checkout
                        cartController.clearCart();

                        Get.defaultDialog(
                          title: 'Pesanan Berhasil!',
                          middleText: 'Terima kasih telah berbelanja di TokoKita.',
                          textConfirm: 'Kembali ke Beranda',
                          confirmTextColor: Colors.white,
                          buttonColor: Colors.deepPurple,
                          onConfirm: () {
                            Get.offAllNamed('/');
                          },
                        );
                      },
                      child: const Text(
                        'Konfirmasi & Bayar Sekarang',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}