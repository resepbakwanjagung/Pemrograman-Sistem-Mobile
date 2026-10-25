import 'package:flutter/material.dart';

/// Widget Custom pendukung untuk menampilkan harga produk dalam format Rupiah
class PriceLabel extends StatelessWidget {
  final double price;
  final TextStyle? style;

  const PriceLabel({
    super.key,
    required this.price,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    // Format nominal ke angka berpemisah titik
    final formattedPrice = 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

    return Text(
      formattedPrice,
      style: style ??
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.indigo.shade700,
          ),
    );
  }
}
