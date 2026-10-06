class AssignmentModel {
  final String id;
  final String judul;
  final String? deskripsi;
  final DateTime deadline;
  final String jenis;
  final String namaMatkul;

  const AssignmentModel({
    required this.id,
    required this.judul,
    this.deskripsi,
    required this.deadline,
    required this.jenis,
    required this.namaMatkul,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    final course = json['course'] as Map<String, dynamic>? ?? {};
    return AssignmentModel(
      id: json['id'] as String? ?? '',
      judul: json['judul'] as String? ?? '',
      deskripsi: json['deskripsi'] as String?,
      deadline: DateTime.tryParse(json['deadline'] as String? ?? '') ?? DateTime.now(),
      jenis: json['jenis'] as String? ?? 'TUGAS',
      namaMatkul: course['namaMatkul'] as String? ?? '',
    );
  }
}
