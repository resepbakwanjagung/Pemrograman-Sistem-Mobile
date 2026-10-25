import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../widgets/price_label.dart';
import '../widgets/stock_badge.dart';
import '../widgets/category_tag.dart';
import '../controllers/cart_controller.dart';
import '../services/product_service.dart';

/// Halaman Detail Produk (Pertemuan 5–7):
/// Mengambil detail produk dari endpoint GET /products/{id} via fetchProductDetail,
/// dilengkapi loading indicator, fallback data lokal, kontrol kuantitas, dan tambah ke keranjang GetX.
class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ProductService _productService = ProductService();
  late Future<Product> _detailFuture;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    final int? productId = int.tryParse(widget.product.id);
    if (productId != null) {
      _detailFuture = _productService.fetchProductDetail(productId);
    } else {
      _detailFuture = Future.value(widget.product);
    }
  }

  void _incrementQuantity(int maxStock) {
    if (_quantity < maxStock) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: FutureBuilder<Product>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.deepPurple),
                  SizedBox(height: 12),
                  Text('Memuat detail produk dari server...'),
                ],
              ),
            );
          }

          // Gunakan data dari API jika sukses, atau fallback ke widget.product jika gagal
          final product = snapshot.hasData ? snapshot.data! : widget.product;
          final isDiscounted = product is DiscountedProduct;
          final discountedProduct = product is DiscountedProduct ? product : null;
          final finalPrice = isDiscounted && discountedProduct != null
              ? discountedProduct.hitungHargaFinal()
              : product.price;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar Produk dari URL API atau Placeholder
                Container(
                  height: 260,
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: product.imageUrl.startsWith('http')
                      ? Image.network(
                          product.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              _getCategoryIcon(product.category),
                              size: 100,
                              color: Colors.deepPurple.shade300,
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            _getCategoryIcon(product.category),
                            size: 100,
                            color: Colors.deepPurple.shade300,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryTag(category: product.category),
                          StockBadge(stock: product.stock),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PriceLabel(
                            price: finalPrice,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple.shade700,
                            ),
                          ),
                          if (isDiscounted && discountedProduct != null) ...[
                            const SizedBox(width: 10),
                            Text(
                              product.formattedPrice,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Diskon ${discountedProduct.discountPercent.toInt()}%',
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Divider(height: 32),
                      const Text(
                        'Deskripsi Produk',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description ?? 'Tidak ada deskripsi untuk produk ini.',
                        style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
                      ),
                      const Divider(height: 32),
                      const Text(
                        'Jumlah Pembelian',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  onPressed: product.stock > 0 ? _decrementQuantity : null,
                                ),
                                Text(
                                  '$_quantity',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),
                                  onPressed: product.stock > _quantity
                                      ? () => _incrementQuantity(product.stock)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Tersisa ${product.stock} buah',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text(
              'Tambah ke Keranjang',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: widget.product.stock <= 0
                ? null
                : () {
                    cartController.addToCart(widget.product, quantity: _quantity);

                    Get.rawSnackbar(
                      message: '$_quantity ${widget.product.name} telah masuk ke keranjang belanja.',
                      backgroundColor: Colors.deepPurple,
                      duration: const Duration(seconds: 2),
                      snackPosition: SnackPosition.BOTTOM,
                    );

                    Navigator.of(context).pop();
                  },
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
      case 'elektronik':
        return Icons.devices;
      case "men's clothing":
      case "women's clothing":
      case 'fashion':
        return Icons.checkroom;
      case 'jewelery':
        return Icons.diamond_outlined;
      case 'makanan':
        return Icons.fastfood;
      default:
        return Icons.shopping_bag;
    }
  }
}
