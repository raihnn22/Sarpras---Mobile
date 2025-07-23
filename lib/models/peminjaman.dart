class Peminjaman {
  final int id;
  final int userId;
  final int barangId;
  final String tanggalPinjam;
  final String? tanggalKembali;
  final String status;

  Peminjaman({
    required this.id,
    required this.userId,
    required this.barangId,
    required this.tanggalPinjam,
    this.tanggalKembali,
    required this.status,
  });

  // Dari JSON ke object
  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      id: json['id'],
      userId: json['user_id'],
      barangId: json['barang_id'],
      tanggalPinjam: json['tanggal_pinjam'],
      tanggalKembali: json['tanggal_kembali'],
      status: json['status'],
    );
  }

  // Dari object ke JSON (saat kirim POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'barang_id': barangId,
      'tanggal_pinjam': tanggalPinjam,
      'tanggal_kembali': tanggalKembali,
      'status': status,
    };
  }
}
