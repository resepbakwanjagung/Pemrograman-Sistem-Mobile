import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/price_label.dart';
import '../widgets/stock_badge.dart';
import '../widgets/category_tag.dart';

/// Halaman Detail Produk (Pertemuan 5):
/// Menampilkan informasi lengkap produk, kontrol quantity (tambah/kurang),
/// dan mengembalikan jumlah yang ditambahkan ke keranjang via Navigator.pop(context, quantity).
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
  int _quantity = 1;

  void _incrementQuantity() {
    if (_quantity < widget.product.stock) {
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
    final isDiscounted = widget.product is DiscountedProduct;
    final discountedProduct = isDiscounted ? widget.product as DiscountedProduct : null;
    final finalPrice = isDiscounted && discountedProduct != null
        ? discountedProduct.hitungHargaFinal()
        : widget.product.price;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar / Placeholder Header
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.deepPurple.shade50,
              child: Center(
                child: Icon(
                  _getCategoryIcon(widget.product.category),
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
                  // Kategori & Badge Stok
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryTag(category: widget.product.category),
                      StockBadge(stock: widget.product.stock),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Nama Produk
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Harga & Badge Diskon
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
                          widget.product.formattedPrice,
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

                  // Deskripsi Produk
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description ?? 'Tidak ada deskripsi untuk produk ini.',
                    style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
                  ),

                  const Divider(height: 32),

                  // Kontrol Jumlah Produk (Quantity)
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
                              onPressed: widget.product.stock > 0 ? _decrementQuantity : null,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: widget.product.stock > _quantity ? _incrementQuantity : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Tersisa ${widget.product.stock} buah',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
                    // Mengembalikan jumlah item ke halaman sebelumnya
                    Navigator.pop(context, _quantity);
                  },
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'elektronik':
        return Icons.devices;
      case 'fashion':
        return Icons.checkroom;
      case 'makanan':
        return Icons.fastfood;
      default:
        return Icons.shopping_bag;
    }
  }
}