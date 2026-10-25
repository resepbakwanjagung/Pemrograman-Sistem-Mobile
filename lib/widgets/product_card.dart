import 'package:flutter/material.dart';
import '../models/product.dart';
import 'price_label.dart';
import 'stock_badge.dart';
import 'category_tag.dart';

/// Langkah 2, 3, & 5 (Pertemuan 4) + Navigasi ke Detail (Pertemuan 5):
/// Menambahkan onTap InkWell untuk navigasi ke named route '/detail' dan menerima kembalian data.
class ProductCard extends StatefulWidget {
  final Product product;
  final void Function(int quantity)? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    print('[ProductCard Lifecycle] initState() dipanggil untuk produk: ${widget.product.name}');
  }

  @override
  Widget build(BuildContext context) {
    print('[ProductCard Lifecycle] build() dipanggil untuk produk: ${widget.product.name}');
    final isDiscounted = widget.product is DiscountedProduct;
    final discountedProduct = isDiscounted ? widget.product as DiscountedProduct : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            // Navigasi ke named route '/detail' dengan mengirim objek product
            final result = await Navigator.pushNamed(
              context,
              '/detail',
              arguments: widget.product,
            );

            // Menerima nilai kembalian (jumlah barang) jika ditambahkan ke keranjang
            if (result != null && result is int && context.mounted) {
              if (widget.onAddToCart != null) {
                widget.onAddToCart!(result);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Berhasil menambahkan $result ${widget.product.name} ke keranjang!',
                    ),
                    backgroundColor: Colors.deepPurple,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar / Thumbnail Produk dengan Stack & Positioned
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            _getCategoryIcon(widget.product.category),
                            size: 44,
                            color: Colors.deepPurple.shade400,
                          ),
                        ),
                      ),
                      if (isDiscounted && discountedProduct != null)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${discountedProduct.discountPercent.toInt()}% OFF',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: StockBadge(stock: widget.product.stock),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                // Detail Informasi Produk
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CategoryTag(category: widget.product.category),
                      const SizedBox(height: 4),
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Flexible(
                            child: PriceLabel(
                              price: isDiscounted && discountedProduct != null
                                  ? discountedProduct.hitungHargaFinal()
                                  : widget.product.price,
                            ),
                          ),
                          if (isDiscounted) ...[
                            const SizedBox(width: 6),
                            Text(
                              widget.product.formattedPrice,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Tombol Aksi Favorit
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                      print(
                        '[ProductCard State] setState() dipanggil: Favorite ${widget.product.name} = $_isFavorite',
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('[ProductCard Lifecycle] dispose() dipanggil untuk produk: ${widget.product.name}');
    super.dispose();
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