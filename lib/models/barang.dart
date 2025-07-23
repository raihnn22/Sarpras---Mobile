class Barang {
  final String id;
  final String nama_barang;
  final String kode_barang;
  final String gambar_barang;

  Barang({
    required this.id,
    required this.nama_barang,
    required this.kode_barang,
    required this.gambar_barang,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id'].toString(),
      nama_barang: json['nama'] ?? 'Nama tidak tersedia', // jika null
      kode_barang: json['kode'] ?? 'Kode tidak tersedia', // jika null
      gambar_barang: json['gambar'] ?? '', // jika null
    );
  }
}
