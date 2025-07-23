import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'dart:convert';
import 'pengembalian_page.dart';

class PeminjamanPage extends StatefulWidget {
  @override
  _PeminjamanPageState createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  String? selectedBarangId;
  String alasan = '';
  String ruangan = '';
  TimeOfDay? jamKembali;
  String tanggalPinjam = DateTime.now().toIso8601String().split('T')[0];
  List<dynamic> barangList = [];
  String siswaId = '1'; // Ganti dengan ID siswa yang sesuai

  @override
  void initState() {
    super.initState();
    fetchBarang();
  }

  Future<void> pilihTanggalPinjam(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        tanggalPinjam = picked.toIso8601String().split('T')[0];
      });
    }
  }

  Future<void> pilihJamKembali(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        jamKembali = picked;
      });
    }
  }

  Future<void> fetchBarang() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/barangs'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          barangList = data['data'];
        });
      } else {
        showSnackBar('Gagal memuat data barang');
      }
    } catch (e) {
      showSnackBar('Terjadi kesalahan: $e');
    }
  }

  Future<void> kirimPeminjaman() async {
    if (selectedBarangId == null ||
        alasan.isEmpty ||
        jamKembali == null ||
        ruangan.isEmpty) {
      showSnackBar('Lengkapi semua kolom terlebih dahulu');
      return;
    }

    final now = DateTime.now();
    final jamMulai =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final jamKembaliFormatted =
        '${jamKembali!.hour.toString().padLeft(2, '0')}:${jamKembali!.minute.toString().padLeft(2, '0')}';

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/peminjaman'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'siswa_id': siswaId,
          'barang_id': selectedBarangId,
          'tanggal_pinjam': tanggalPinjam,
          'jam_mulai': jamMulai,
          'jam_kembali': jamKembaliFormatted,
          'alasan': alasan,
          'ruangan': ruangan,
        }),
      );

      if (response.statusCode == 201) {
        showSnackBar('Peminjaman berhasil dikirim');
        setState(() {
          selectedBarangId = null;
          alasan = '';
          jamKembali = null;
          ruangan = '';
        });
      } else {
        final error = jsonDecode(response.body);
        showSnackBar('${error['message'] ?? 'Terjadi kesalahan'}');
      }
    } catch (e) {
      showSnackBar('Gagal mengirim peminjaman: $e');
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Hapus AppBar untuk menghilangkan tombol back
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Form Peminjaman',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedBarangId,
                  hint: Text('Pilih Barang'),
                  items: barangList.map<DropdownMenuItem<String>>((item) {
                    return DropdownMenuItem<String>(
                      value: item['id'].toString(),
                      child: Text(item['kode'] ?? 'Barang'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBarangId = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(labelText: 'Ruangan'),
                  onChanged: (value) {
                    setState(() {
                      ruangan = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(jamKembali == null
                        ? 'Pilih Jam Pengembalian'
                        : 'Jam Kembali: ${jamKembali!.format(context)}'),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () => pilihJamKembali(context),
                      child: Text('Pilih Jam'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Tanggal Pinjam: $tanggalPinjam'),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () => pilihTanggalPinjam(context),
                      child: Text('Pilih Tanggal'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(labelText: 'Alasan Peminjaman'),
                  onChanged: (value) {
                    alasan = value;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: kirimPeminjaman,
                  child: Text('Kirim Peminjaman'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Sesuaikan ini dengan halaman aktif
        selectedItemColor: Colors.blue, // Samakan warnanya
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(nama: 'Siswa'),
              ),
              (route) => false,
            );
          } else if (index == 1) {
            // Halaman ini sendiri, tidak perlu pindah
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PengembalianPage()),
            );
          } else if (index == 3) {
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
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
      ),
    );
  }
}
