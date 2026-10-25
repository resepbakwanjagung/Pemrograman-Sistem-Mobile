import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

/// Langkah 1 & 4 (Pertemuan 4):
/// Halaman utama (HomePage) dengan App Bar kustom menggunakan Row & Column,
/// serta daftar produk efisien dengan ListView.builder.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header Halaman menggunakan Container, Row, dan Column
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
                  // Judul dan subjudul disusun secara vertikal dengan Column
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

                  // Ikon Keranjang Belanja di sisi kanan header
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.deepPurple),
                    tooltip: 'Keranjang Belanja',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Keranjang belanja belum tersedia'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Daftar Produk TokoKita menggunakan ListView.builder
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