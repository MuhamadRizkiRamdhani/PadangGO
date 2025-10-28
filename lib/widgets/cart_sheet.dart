import 'package:flutter/material.dart';
import 'package:aplikasi_katalog/models/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item_row.dart';
import 'success_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

class KeranjangSheet extends StatefulWidget {
  final List<KeranjangItem> keranjang;
  final VoidCallback onUpdate;

  const KeranjangSheet({
    Key? key,
    required this.keranjang,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<KeranjangSheet> createState() => _KeranjangSheetState();
}

class _KeranjangSheetState extends State<KeranjangSheet> {
  Future<void> _simpanPesanan({
    required String alamat,
    required String pembayaran,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('orders').add({
      'userId': user?.uid ?? '',
      'email': user?.email ?? '',
      'produk': widget.keranjang
          .map(
            (item) => {
              'nama': item.produk.nama,
              'deskripsi': item.produk.deskripsi,
              'imageUrl': item.produk.imageUrl,
              'harga': item.produk.harga,
              'jumlah': item.jumlah,
            },
          )
          .toList(),
      'jumlah': widget.keranjang.fold(0, (sum, item) => sum + item.jumlah),
      'total_harga': totalHarga,
      'waktu': FieldValue.serverTimestamp(),
      'alamat': alamat,
      'pembayaran': pembayaran,
    });
  }

  double get totalHarga => widget.keranjang.fold(
    0,
    (t, item) => t + (item.produk.harga * item.jumlah),
  );

  @override
  Widget build(BuildContext context) {
    final alamatController = TextEditingController();
    String pembayaran = 'COD';
    return Container(
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Keranjang',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                if (widget.keranjang.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text('Keranjang masih kosong.')),
                  )
                else ...[
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      itemCount: widget.keranjang.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, i) {
                        final item = widget.keranjang[i];
                        return KeranjangItemRow(
                          item: item,
                          onAdd: () {
                            setState(() {});
                            item.jumlah++;
                            widget.onUpdate();
                          },
                          onRemove: () {
                            setState(() {});
                            if (item.jumlah > 1) {
                              item.jumlah--;
                            } else {
                              widget.keranjang.removeAt(i);
                            }
                            widget.onUpdate();
                          },
                          onDelete: () {
                            setState(() {});
                            widget.keranjang.removeAt(i);
                            widget.onUpdate();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Rp ${totalHarga.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                      shadowColor: Colors.amber[200],
                      textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        letterSpacing: 0.5,
                      ),
                    ),
                    onPressed: widget.keranjang.isEmpty
                        ? null
                        : () async {
                            await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) {
                                return AlertDialog(
                                  backgroundColor: const Color(0xFFF5F5F5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  title: Text(
                                    'Lengkapi Pesanan',
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextField(
                                        controller: alamatController,
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: 'Alamat Pengiriman',
                                          labelStyle: TextStyle(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 10,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        minLines: 1,
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 14),
                                      DropdownButtonFormField<String>(
                                        value: pembayaran,
                                        items: [
                                          DropdownMenuItem(
                                            value: 'COD',
                                            child: Text(
                                              'COD (Bayar di Tempat)',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                        onChanged: (val) {
                                          if (val != null) pembayaran = val;
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Metode Pembayaran',
                                          labelStyle: TextStyle(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 10,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: Text(
                                        'Batal',
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber,
                                        foregroundColor: Colors.white,
                                        textStyle: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final alamat = alamatController.text
                                            .trim();
                                        if (alamat.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Alamat harus diisi!',
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        Navigator.of(ctx).pop({
                                          'alamat': alamat,
                                          'pembayaran': pembayaran,
                                        });
                                      },
                                      child: const Text('Pesan'),
                                    ),
                                  ],
                                );
                              },
                            ).then((result) async {
                              if (result is Map && result['alamat'] != null) {
                                await _simpanPesanan(
                                  alamat: result['alamat'],
                                  pembayaran: result['pembayaran'] ?? 'COD',
                                );
                                await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) => const SuccessDialog(),
                                );
                                if (mounted) {
                                  setState(() => widget.keranjang.clear());
                                  widget.onUpdate();
                                  Navigator.of(context).pop();
                                }
                              }
                            });
                          },
                    child: const Text('Pesan Sekarang'),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.bottom + 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
