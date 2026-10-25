import 'package:flutter/material.dart';
import '../models/product.dart';
import 'price_label.dart';
import 'stock_badge.dart';
import 'category_tag.dart';

/// Langkah 2: ProductCard sebagai StatefulWidget dengan pengamatan Lifecycle
class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  State<ProductCard> createState() {
    return _ProductCardState();
  }
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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar / Icon Placeholder & Tombol Favorit
            Stack(
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      _getCategoryIcon(widget.product.category),
                      size: 64,
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withAlpha(230),
                    child: IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                          print('[ProductCard State] setState() dipanggil: Favorite ${widget.product.name} = $_isFavorite');
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Header Row: Nama & StockBadge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                StockBadge(stock: widget.product.stock),
              ],
            ),
            const SizedBox(height: 8),
            // Footer Row: PriceLabel & CategoryTag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PriceLabel(price: widget.product.price),
                CategoryTag(category: widget.product.category),
              ],
            ),
          ],
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
