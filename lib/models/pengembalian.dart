class Pengembalian {
  final int id;
  final int peminjamanId;
  final String tanggalPengembalian;
  final String jamPengembalian;

  Pengembalian({
    required this.id,
    required this.peminjamanId,
    required this.tanggalPengembalian,
    required this.jamPengembalian,
  });

  factory Pengembalian.fromJson(Map<String, dynamic> json) {
    return Pengembalian(
      id: json['id'],
      peminjamanId: json['peminjaman_id'],
      tanggalPengembalian: json['tanggal_pengembalian'],
      jamPengembalian: json['jam_pengembalian'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'peminjaman_id': peminjamanId,
      'tanggal_pengembalian': tanggalPengembalian,
      'jam_pengembalian': jamPengembalian,
    };
  }
}
