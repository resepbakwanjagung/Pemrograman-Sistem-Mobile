import 'package:flutter/material.dart';
import 'models/product.dart';
import 'screens/main_page.dart';
import 'screens/product_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokoKita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Inisialisasi rute awal pada MainPage (Bottom Navigation)
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
      },
      // Penanganan named routes dengan arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final product = settings.arguments as Product;
          return MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          );
        }
        return null;
      },
    );
  }
}