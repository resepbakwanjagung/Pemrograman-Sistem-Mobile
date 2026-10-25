import 'package:flutter/material.dart';

/// Widget Custom pendukung untuk menampilkan badge status stok produk
class StockBadge extends StatelessWidget {
  final int stock;

  const StockBadge({
    super.key,
    required this.stock,
  });

  String get _statusText {
    if (stock <= 0) return 'Habis';
    if (stock <= 5) return 'Stok Terbatas';
    return 'Tersedia';
  }

  Color get _badgeColor {
    if (stock <= 0) return Colors.red.shade100;
    if (stock <= 5) return Colors.orange.shade100;
    return Colors.green.shade100;
  }

  Color get _textColor {
    if (stock <= 0) return Colors.red.shade900;
    if (stock <= 5) return Colors.orange.shade900;
    return Colors.green.shade900;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _badgeColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _textColor.withAlpha(80)),
      ),
      child: Text(
        _statusText,
        style: TextStyle(
          color: _textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
