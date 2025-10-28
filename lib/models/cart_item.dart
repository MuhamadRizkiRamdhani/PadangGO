import 'package:aplikasi_katalog/models/product.dart';

class KeranjangItem {
  final Produk produk;
  int jumlah;
  KeranjangItem({required this.produk, this.jumlah = 1});
}
