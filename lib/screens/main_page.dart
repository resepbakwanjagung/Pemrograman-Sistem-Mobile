import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import 'home_page.dart';
import 'cart_page.dart';

/// Halaman Utama (MainPage) dengan BottomNavigationBar (Pertemuan 5 & 6):
/// Mendaftarkan CartController secara global dengan Get.put,
/// menampilkan badge reaktif pada tab Keranjang, serta menghubungkan tab ke CartPage nyata.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // Inisialisasi CartController satu kali di tingkat atas aplikasi
  final CartController _cartController = Get.find<CartController>();

  final List<Widget> _pages = const [
    HomePage(),
    CartPage(),
    ProfilePlaceholderPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: _cartController.totalItem > 0,
                label: Text('${_cartController.totalItem}'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: _cartController.totalItem > 0,
                label: Text('${_cartController.totalItem}'),
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Keranjang',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder Halaman Profil
class ProfilePlaceholderPage extends StatelessWidget {
  const ProfilePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.deepPurple.shade100,
              child: const Icon(Icons.person, size: 50, color: Colors.deepPurple),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pengguna TokoKita',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'user@tokokita.com',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}