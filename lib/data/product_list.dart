import 'package:aplikasi_katalog/models/product.dart';

final List<Produk> produkList = [
  Produk(
    nama: 'Nasi',
    deskripsi: 'Nasi putih tawar dan mengenyangkan',
    imageUrl:
        'https://static.honestdocs.id/system/blog_articles/main_hero_images/000/005/813/original/iStock-1138408361_(1).jpg',
    harga: 3000,
  ),
  Produk(
    nama: 'Rendang',
    deskripsi: 'Rendang daging sapi empuk dan enak',
    imageUrl:
        'https://www.dapurkobe.co.id/wp-content/uploads/rendang-daging.jpg',
    harga: 8000,
  ),
  Produk(
    nama: 'Rendang Ayam',
    deskripsi: 'Rendang daging ayam kaya rasa',
    imageUrl:
        'https://dailymakan.com/wp-content/uploads/2019/08/Rendang-Ayam.jpg',
    harga: 8000,
  ),
  Produk(
    nama: 'Perkedel Kentang',
    deskripsi: 'Gorengan perkedel kentang dengan balutan telur',
    imageUrl:
        'https://4.bp.blogspot.com/-gDkdGIN0CGo/Wi7IkDMAZAI/AAAAAAAAI5U/Y31XWDChIB0ILqg69BpXVNZSRyr91KtmACKgBGAs/s1600/IMG_3727.JPG',
    harga: 2000,
  ),
  Produk(
    nama: 'Telur Barendo',
    deskripsi: 'Telur goreng garing dan rendah minyak',
    imageUrl:
        'https://www.finnafood.com/blog/wp-content/uploads/2024/07/resep-telur-barendo.jpg',
    harga: 5000,
  ),
  Produk(
    nama: 'Ayam Cabe Hijau',
    deskripsi: 'Olahan ayam pedas dengan cabai hijau',
    imageUrl:
        'https://img-global.cpcdn.com/recipes/7d7264e9f74c496e/680x482cq70/ayam-cabe-ijo-simple-foto-resep-utama.jpg',
    harga: 8000,
  ),
  Produk(
    nama: 'Sambal Ijo',
    deskripsi: 'Sambal Hijau Khas Padang',
    imageUrl:
        'https://2.bp.blogspot.com/-t9kI0oeHqxU/V8vwrRn62GI/AAAAAAAAGtc/KRY9SRNBsYcNLmSqxguFsGhQjbChcOvmACLcB/s1600/Resep%2BSambal%2BIjo%2BPadang.png',
    harga: 3500,
  ),
  Produk(
    nama: 'Gulai Kambing',
    deskripsi: 'Gulai kambing dengan isian jeroan kambing yang enak',
    imageUrl:
        'https://th.bing.com/th/id/R.c4f3c1d1f26e156571ede06c62428571?rik=3KayhAv7%2bkMqhQ&riu=http%3a%2f%2f3.bp.blogspot.com%2f-gRgx_ezUNbk%2fUgEEyfLk3xI%2fAAAAAAAAIws%2fNDmnDdxlCkA%2fs1600%2fIMG_5840.JPG&ehk=H501%2fG7gGdB29UhqCqne9iVCRR1qNRwlgJ7iihg4OFQ%3d&risl=&pid=ImgRaw&r=0',
    harga: 10000,
  ),
  Produk(
    nama: 'Sayur Nangka',
    deskripsi: 'Sayur nangka dengan bumbu khas padang',
    imageUrl: 'https://i.ytimg.com/vi/SkV4LZfuOuE/maxresdefault.jpg',
    harga: 5000,
  ),
  Produk(
    nama: 'Daun Singkong',
    deskripsi: 'Makanan pelengkap khas nasi padang',
    imageUrl:
        'https://www.biotifor.or.id/wp-content/uploads/2023/09/jose-2023-09-21T184249.093.jpg',
    harga: 3000,
  ),
];

void debugPrintProdukList() {
  print(
    'Loaded produkList: ' + produkList.map((p) => p.nama).toList().toString(),
  );
}
