import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../controllers/cart_controller.dart';
import '../services/product_service.dart';
import 'cart_page.dart';

/// Halaman Beranda Utama (Pertemuan 4–7):
/// Mengambil data produk asli dari REST API (Fake Store API) menggunakan FutureBuilder,
/// dilengkapi loading indicator, penanganan error ramah, tombol Coba Lagi, dan RefreshIndicator.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _productsFuture = _productService.fetchProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _loadProducts();
    });
    await _productsFuture;
  }

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

            // Daftar Produk TokoKita via REST API & FutureBuilder
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  // 1. Kondisi Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.deepPurple),
                          SizedBox(height: 14),
                          Text('Memuat produk dari server...'),
                        ],
                      ),
                    );
                  }

                  // 2. Kondisi Error
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_off, size: 70, color: Colors.red.shade400),
                            const SizedBox(height: 16),
                            const Text(
                              'Gagal Memuat Produk',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Periksa koneksi internet Anda atau coba sesaat lagi.\n(${snapshot.error})',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Coba Lagi'),
                              onPressed: () {
                                setState(() {
                                  _loadProducts();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // 3. Kondisi Data Kosong
                  final products = snapshot.data ?? [];
                  if (products.isEmpty) {
                    return const Center(child: Text('Tidak ada produk tersedia.'));
                  }

                  // 4. Kondisi Sukses dengan RefreshIndicator (Pull-to-refresh)
                  return RefreshIndicator(
                    onRefresh: _refreshProducts,
                    color: Colors.deepPurple,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          key: ValueKey(product.id),
                          product: product,
                        );
                      },
                    ),
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