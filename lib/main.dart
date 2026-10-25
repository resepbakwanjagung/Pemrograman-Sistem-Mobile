import 'package:flutter/material.dart';
import 'models/product.dart';
import 'widgets/product_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokoKita - Pertemuan 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TokoKitaHomePage(),
    );
  }
}

class TokoKitaHomePage extends StatefulWidget {
  const TokoKitaHomePage({super.key});

  @override
  State<TokoKitaHomePage> createState() => _TokoKitaHomePageState();
}

class _TokoKitaHomePageState extends State<TokoKitaHomePage> {
  bool _showAll = true;

  @override
  Widget build(BuildContext context) {
    final productsToDisplay = _showAll ? dummyProducts : dummyProducts.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TokoKita - Pertemuan 3'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_showAll ? Icons.filter_list : Icons.filter_list_off),
            tooltip: 'Toggle Filter Produk (Pengujian Lifecycle Dispose)',
            onPressed: () {
              setState(() {
                _showAll = !_showAll;
              });
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Produk TokoKita (${productsToDisplay.length})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  _showAll ? 'Menampilkan Semua' : 'Filter Top 3',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: productsToDisplay.length,
              itemBuilder: (context, index) {
                final product = productsToDisplay[index];
                return ProductCard(
                  key: ValueKey(product.id),
                  product: product,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
