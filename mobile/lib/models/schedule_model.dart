class ScheduleModel {
  final String id;
  final String kodeMatkul;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final String ruang;
  final String namaMatkul;
  final String dosen;
  final int sks;

  const ScheduleModel({
    required this.id,
    required this.kodeMatkul,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.ruang,
    required this.namaMatkul,
    required this.dosen,
    required this.sks,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    final course = json['course'] as Map<String, dynamic>? ?? {};
    return ScheduleModel(
      id: json['id'] as String? ?? '',
      kodeMatkul: course['kodeMatkul'] as String? ?? json['kodeMatkul'] as String? ?? 'CIE',
      hari: json['hari'] as String? ?? '',
      jamMulai: json['jamMulai'] as String? ?? '',
      jamSelesai: json['jamSelesai'] as String? ?? '',
      ruang: json['ruang'] as String? ?? '',
      namaMatkul: course['namaMatkul'] as String? ?? json['namaMatkul'] as String? ?? '',
      dosen: course['dosen'] as String? ?? json['dosen'] as String? ?? '',
      sks: course['sks'] as int? ?? json['sks'] as int? ?? 3,
    );
  }
}
