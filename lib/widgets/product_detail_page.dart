import 'package:flutter/material.dart';
import 'package:aplikasi_katalog/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Produk product;
  final void Function(Produk product)? onAddToCart;
  const ProductDetailPage({Key? key, required this.product, this.onAddToCart})
    : super(key: key);

  List<Map<String, dynamic>> getComposition() {
    if (product.nama.contains('Paket Hemat 1')) {
      return [
        {'icon': Icons.rice_bowl, 'label': 'Nasi'},
        {'icon': Icons.set_meal, 'label': 'Ayam Goreng'},
        {'icon': Icons.local_fire_department, 'label': 'Sambal Ijo'},
        {'icon': Icons.eco, 'label': 'Lalapan'},
        {'icon': Icons.local_drink, 'label': 'Teh Manis'},
      ];
    } else if (product.nama.contains('Paket Hemat 2')) {
      return [
        {'icon': Icons.rice_bowl, 'label': 'Nasi'},
        {'icon': Icons.set_meal, 'label': 'Rendang'},
        {'icon': Icons.egg, 'label': 'Telur Balado'},
        {'icon': Icons.spa, 'label': 'Sayur Nangka'},
        {'icon': Icons.local_drink, 'label': 'Es Teh'},
      ];
    } else if (product.nama.contains('Paket Hemat 3')) {
      return [
        {'icon': Icons.rice_bowl, 'label': 'Nasi'},
        {'icon': Icons.set_meal, 'label': 'Ayam Bakar'},
        {'icon': Icons.lunch_dining, 'label': 'Perkedel'},
        {'icon': Icons.local_fire_department, 'label': 'Sambal Merah'},
        {'icon': Icons.local_drink, 'label': 'Air Mineral'},
      ];
    }
    return [
      {'icon': Icons.rice_bowl, 'label': 'Nasi'},
      {'icon': Icons.set_meal, 'label': 'Lauk'},
      {'icon': Icons.local_drink, 'label': 'Minuman'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final composition = getComposition();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          product.nama,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF222222),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  child: Image.network(
                    product.imageUrl,
                    width: double.infinity,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ),
                if (product.nama.contains('Paket Hemat'))
                  Positioned(
                    top: 18,
                    left: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber[700],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Favorite Package',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18, left: 20, right: 20),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber[700], size: 22),
                  const SizedBox(width: 4),
                  const Text(
                    '4.8',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '(120 reviews)',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.blueAccent),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                children: composition
                    .map(
                      (item) => Chip(
                        avatar: Icon(
                          item['icon'],
                          size: 18,
                          color: Colors.amber[800],
                        ),
                        label: Text(
                          item['label'],
                          style: const TextStyle(fontSize: 13),
                        ),
                        backgroundColor: Colors.amber[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Colors.grey.withOpacity(0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nama,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${product.harga.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    product.deskripsi,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[800],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (onAddToCart != null) onAddToCart!(product);
                        Navigator.pop(context, true);
                      },
                      icon: const Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Masukkan ke Keranjang!',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
