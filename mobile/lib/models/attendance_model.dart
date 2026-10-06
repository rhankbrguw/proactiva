class AttendanceSummaryModel {
  final String courseId;
  final String kodeMatkul;
  final String namaMatkul;
  final int sks;
  final String dosen;
  final int totalAbsen;
  final int maxAllowedAbsen;
  final String warningLevel; // SAFE, WARNING, CRITICAL

  const AttendanceSummaryModel({
    required this.courseId,
    required this.kodeMatkul,
    required this.namaMatkul,
    required this.sks,
    required this.dosen,
    required this.totalAbsen,
    required this.maxAllowedAbsen,
    required this.warningLevel,
  });

  double get persentaseKehadiran => ((14 - totalAbsen) / 14.0 * 100.0);

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      courseId: json['courseId'] as String? ?? '',
      kodeMatkul: json['kodeMatkul'] as String? ?? '',
      namaMatkul: json['namaMatkul'] as String? ?? '',
      sks: json['sks'] as int? ?? 3,
      dosen: json['dosen'] as String? ?? '',
      totalAbsen: json['totalAbsen'] as int? ?? 0,
      maxAllowedAbsen: json['maxAllowedAbsen'] as int? ?? 4,
      warningLevel: json['warningLevel'] as String? ?? 'SAFE',
    );
  }
}
