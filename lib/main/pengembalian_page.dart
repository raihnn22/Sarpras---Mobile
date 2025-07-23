import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart';
import 'peminjaman_page.dart';

class PengembalianPage extends StatefulWidget {
  @override
  _PengembalianPageState createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  List<dynamic> peminjamanList = [];
  String? selectedPeminjamanId;

  @override
  void initState() {
    super.initState();
    fetchPeminjaman();
  }

  Future<void> fetchPeminjaman() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/peminjaman-diterima'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          peminjamanList = data['data'];
        });
      } else {
        showSnackBar('Gagal memuat data peminjaman');
      }
    } catch (e) {
      showSnackBar('Terjadi kesalahan: $e');
    }
  }

  Future<void> kirimPengembalian() async {
    if (selectedPeminjamanId == null) {
      showSnackBar('Pilih peminjaman terlebih dahulu');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/pengembalian'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'peminjaman_id': selectedPeminjamanId,
        }),
      );

      if (response.statusCode == 201) {
        showSnackBar('Pengembalian berhasil dikirim');
        setState(() {
          selectedPeminjamanId = null;
        });
      } else {
        final error = jsonDecode(response.body);
        print('STATUS: ${response.statusCode}');
        print('RESPONSE BODY: ${response.body}');
        showSnackBar('${error['message'] ?? 'Terjadi kesalahan'}');
      }
    } catch (e) {
      showSnackBar('Gagal mengirim pengembalian: $e');
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
        child: Column(
          children: [
            const Text(
              'Form Pengembalian',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: selectedPeminjamanId,
              hint: const Text('Pilih Peminjaman'),
              items: peminjamanList.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item['id'].toString(),
                  child: Text(
                      '${item['barang']['nama']} - ${item['tanggal_pinjam']}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPeminjamanId = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: kirimPengembalian,
              child: const Text('Kirim Pengembalian'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // karena ini halaman pengembalian
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(nama: 'Siswa')),
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PeminjamanPage()),
            );
          } else if (index == 2) {
            // Halaman ini sendiri
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PeminjamanPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Peminjaman'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_return), label: 'Pengembalian'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
      ),
    );
  }
}
