import 'package:flutter/material.dart';
import 'package:aplikasi_katalog/models/product.dart';
import 'package:aplikasi_katalog/models/cart_item.dart';
import 'package:aplikasi_katalog/widgets/cart_sheet.dart';
import 'package:aplikasi_katalog/widgets/product_card.dart';
import 'package:aplikasi_katalog/widgets/image_slider.dart';
import 'package:aplikasi_katalog/widgets/product_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplikasi_katalog/widgets/confirm_logout_dialog.dart';
import 'package:aplikasi_katalog/controls/login_control.dart';
import 'package:aplikasi_katalog/order_history_page.dart';

class ProdukPage extends StatefulWidget {
  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  String getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return '';
    return user.email!.replaceAll('@gmail.com', '');
  }

  Future<void> _showLogoutDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmLogoutDialog(
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
    if (result == true) {
      await logout(context);
    }
  }

  final List<KeranjangItem> keranjang = [];

  String searchQuery = '';
  String selectedFilter = 'Semua';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _showLogoutDialog();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Text(
            'Pesan Makan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF222222),
            ),
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.black, size: 28),
              onSelected: (value) async {
                if (value == 'riwayat') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrderHistoryPage()),
                  );
                } else if (value == 'logout') {
                  await _showLogoutDialog();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'riwayat',
                  child: ListTile(
                    leading: Icon(Icons.history, color: Colors.amber[800]),
                    title: Text('Riwayat Pemesanan'),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.amber[800]),
                    title: Text('Logout'),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFFFF8E1),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Text(
                "Halo! ${getUserName()} silahkan memesan",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari makanan...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.amber,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedFilter,
                            borderRadius: BorderRadius.circular(10),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF795548),
                            ),
                            items:
                                ['Semua', '< 5000', '5000 - 10000', '> 10000']
                                    .map(
                                      (filter) => DropdownMenuItem(
                                        value: filter,
                                        child: Text(filter),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedFilter = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ImageSlider(
                      imageUrls: [
                        'https://media.istockphoto.com/id/1138826636/id/foto/nasi-padang-dengan-rendang.jpg?s=612x612&w=0&k=20&c=yoTy0XC0kgTdjoarYnaqHzYE85vA96wC7dEvxyxgtpA=',
                        'https://i0.wp.com/batamnewsasia.com/wp-content/uploads/2025/01/2-2.png?fit=1600%2C999&ssl=1',
                        'https://www.topwisata.info/wp-content/uploads/2022/01/Nasi-Padang-1-930x620.jpeg.webp',
                      ],
                      titles: [
                        'Paket Hemat 1',
                        'Paket Hemat 2',
                        'Paket Hemat 3',
                      ],
                      onAddToCart: (index) {
                        setState(() {
                          final nama = 'Paket Hemat ${index + 1}';
                          final produk = Produk(
                            nama: nama,
                            deskripsi: [
                              'Paket lengkap nasi Padang dengan ayam goreng renyah, sambal ijo khas, lalapan segar, dan teh manis dingin. Cocok untuk makan siang atau malam yang mengenyangkan!',
                              'Rendang sapi empuk, telur balado pedas, gulai nangka gurih, dan es teh segar. Cita rasa Minang yang otentik dalam satu paket spesial!',
                              'Ayam bakar bumbu rempah, perkedel kentang rumahan, sambal merah pedas, dan air mineral. Pilihan pas untuk pecinta rasa berani dan komplit!',
                            ][index],
                            imageUrl: [
                              'https://media.istockphoto.com/id/1138826636/id/foto/nasi-padang-dengan-rendang.jpg?s=612x612&w=0&k=20&c=yoTy0XC0kgTdjoarYnaqHzYE85vA96wC7dEvxyxgtpA=',
                              'https://i0.wp.com/batamnewsasia.com/wp-content/uploads/2025/01/2-2.png?fit=1600%2C999&ssl=1',
                              'https://www.topwisata.info/wp-content/uploads/2022/01/Nasi-Padang-1-930x620.jpeg.webp',
                            ][index],
                            harga: 15000 + index * 2000,
                          );
                          final idx = keranjang.indexWhere(
                            (item) => item.produk.nama == produk.nama,
                          );
                          if (idx >= 0) {
                            keranjang[idx].jumlah++;
                          } else {
                            keranjang.add(
                              KeranjangItem(produk: produk, jumlah: 1),
                            );
                          }
                        });
                      },
                      onImageTap: (index) {
                        final nama = 'Paket Hemat ${index + 1}';
                        final produk = Produk(
                          nama: nama,
                          deskripsi: [
                            'Paket lengkap nasi Padang dengan ayam goreng renyah, sambal ijo khas, lalapan segar, dan teh manis dingin. Cocok untuk makan siang atau malam yang mengenyangkan!',
                            'Rendang sapi empuk, telur balado pedas, gulai nangka gurih, dan es teh segar. Cita rasa Minang yang otentik dalam satu paket spesial!',
                            'Ayam bakar bumbu rempah, perkedel kentang rumahan, sambal merah pedas, dan air mineral. Pilihan pas untuk pecinta rasa berani dan komplit!',
                          ][index],
                          imageUrl: [
                            'https://media.istockphoto.com/id/1138826636/id/foto/nasi-padang-dengan-rendang.jpg?s=612x612&w=0&k=20&c=yoTy0XC0kgTdjoarYnaqHzYE85vA96wC7dEvxyxgtpA=',
                            'https://i0.wp.com/batamnewsasia.com/wp-content/uploads/2025/01/2-2.png?fit=1600%2C999&ssl=1',
                            'https://www.topwisata.info/wp-content/uploads/2022/01/Nasi-Padang-1-930x620.jpeg.webp',
                          ][index],
                          harga: 15000 + index * 2000,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(
                              product: produk,
                              onAddToCart: (p) {
                                final idx = keranjang.indexWhere(
                                  (item) => item.produk.nama == p.nama,
                                );
                                if (idx >= 0) {
                                  setState(() => keranjang[idx].jumlah++);
                                } else {
                                  setState(
                                    () => keranjang.add(
                                      KeranjangItem(produk: p, jumlah: 1),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final docs = snapshot.data?.docs ?? [];
                          List<Produk> produkList = docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final hargaRaw = data['harga'] ?? '0';
                            final hargaDouble =
                                double.tryParse(hargaRaw.toString()) ?? 0.0;
                            return Produk(
                              nama: data['nama'] ?? '-',
                              deskripsi: data['deskripsi'] ?? '',
                              imageUrl: data['imageUrl'] ?? '',
                              harga: hargaDouble,
                            );
                          }).toList();

                          // Apply search filter
                          if (searchQuery.isNotEmpty) {
                            produkList = produkList
                                .where(
                                  (produk) => produk.nama
                                      .toLowerCase()
                                      .contains(searchQuery.toLowerCase()),
                                )
                                .toList();
                          }
                          if (selectedFilter == '< 5000') {
                            produkList = produkList
                                .where((produk) => produk.harga < 5000)
                                .toList();
                          } else if (selectedFilter == '5000 - 10000') {
                            produkList = produkList
                                .where(
                                  (produk) =>
                                      produk.harga >= 5000 &&
                                      produk.harga <= 10000,
                                )
                                .toList();
                          } else if (selectedFilter == '> 10000') {
                            produkList = produkList
                                .where((produk) => produk.harga > 10000)
                                .toList();
                          }

                          if (produkList.isEmpty) {
                            return const Center(
                              child: Text('Belum ada produk.'),
                            );
                          }
                          return GridView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: produkList.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 180,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.68,
                                ),
                            itemBuilder: (context, index) {
                              final produk = produkList[index];
                              return ProductCard(
                                produk: produk,
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ProductDetailPage(product: produk),
                                    ),
                                  );
                                  if (result == true) {
                                    setState(() {
                                      final idx = keranjang.indexWhere(
                                        (item) =>
                                            item.produk.nama == produk.nama,
                                      );
                                      if (idx >= 0) {
                                        keranjang[idx].jumlah++;
                                      } else {
                                        keranjang.add(
                                          KeranjangItem(
                                            produk: produk,
                                            jumlah: 1,
                                          ),
                                        );
                                      }
                                    });
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'cart',
          backgroundColor: Colors.white,
          elevation: 2,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              builder: (context) {
                return KeranjangSheet(
                  keranjang: keranjang,
                  onUpdate: () => setState(() {}),
                );
              },
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.shopping_cart, color: Colors.amber, size: 28),
              if (keranjang.isNotEmpty)
                Positioned(
                  right: 2,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      keranjang.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
