import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../controllers/cart_controller.dart';
import 'cart_page.dart';

/// Halaman Beranda Utama (Pertemuan 4, 5, & 6):
/// Menampilkan badge reaktif di header via CartController dan Obx.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header Halaman
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'TokoKita',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Belanja jadi lebih mudah',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  // Ikon Keranjang Belanja di Header dengan Badge Reaktif (Obx)
                  Obx(
                    () => IconButton(
                      icon: Badge(
                        isLabelVisible: cartController.totalItem > 0,
                        label: Text('${cartController.totalItem}'),
                        child: const Icon(Icons.shopping_cart_outlined, color: Colors.deepPurple),
                      ),
                      tooltip: 'Keranjang Belanja',
                      onPressed: () {
                        Get.to(() => const CartPage());
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Daftar Produk TokoKita
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: dummyProducts.length,
                itemBuilder: (context, index) {
                  final product = dummyProducts[index];
                  return ProductCard(
                    key: ValueKey(product.id),
                    product: product,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}