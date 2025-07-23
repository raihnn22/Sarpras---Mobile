import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/barang.dart'; // pastikan path ini benar
import 'peminjaman_page.dart'; // 
import 'pengembalian_page.dart';

class HomePage extends StatefulWidget {
  final String? email;
  final String nama;

  const HomePage({
    super.key,
    this.email,
    required this.nama,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Barang> _barangList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBarang();
  }

  Future<void> fetchBarang() async {
    try {
      final response = await http.get(Uri.parse(
        'http://127.0.0.1:8000/api/barangs',
      ));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        setState(() {
          _barangList = data.map((e) => Barang.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        print('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Beranda'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  itemCount: _barangList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 kolom
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final barang = _barangList[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: Image.network(
                                    '${barang.gambar_barang}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        const Icon(Icons.image_not_supported,
                                            size: 48),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    barang.nama_barang,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Kode: ${barang.kode_barang}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    );
                  },
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: Colors.blue, // warna ikon saat dipilih
          unselectedItemColor: Colors.grey, // warna ikon tidak dipilih
          backgroundColor: Colors.white, // warna latar belakang
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PeminjamanPage()),
              );
            } else if (index == 2){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PengembalianPage()),
              );
            } else if (index == 3) {
              // Navigasi ke halaman riwayat
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PengembalianPage()),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment), label: 'Peminjaman'),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_return), label: 'Pengembalian'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'Riwayat'),
          ],
        ));
  }
}
