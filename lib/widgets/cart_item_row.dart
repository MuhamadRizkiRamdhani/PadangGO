import 'package:flutter/material.dart';
import 'package:aplikasi_katalog/models/cart_item.dart';

class KeranjangItemRow extends StatelessWidget {
  final KeranjangItem item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;

  const KeranjangItemRow({
    Key? key,
    required this.item,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            item.produk.nama,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove, size: 18),
              onPressed: onRemove,
            ),
            Text(item.jumlah.toString()),
            IconButton(icon: const Icon(Icons.add, size: 18), onPressed: onAdd),
          ],
        ),
        Text('Rp ${(item.produk.harga * item.jumlah).toStringAsFixed(0)}'),
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          onPressed: onDelete,
        ),
      ],
    );
  }
}
