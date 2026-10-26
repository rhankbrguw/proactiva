class AnnouncementModel {
  final String id;
  final String judul;
  final String isiTeks;
  final DateTime tanggalTerbit;
  final DateTime? extractedDeadline;
  final String? extractedAction;
  final String? targetAudience;
  final String source;

  const AnnouncementModel({
    required this.id,
    required this.judul,
    required this.isiTeks,
    required this.tanggalTerbit,
    this.extractedDeadline,
    this.extractedAction,
    this.targetAudience,
    required this.source,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as String? ?? '',
      judul: json['judul'] as String? ?? '',
      isiTeks: json['isiTeks'] as String? ?? '',
      tanggalTerbit: DateTime.tryParse(json['tanggalTerbit'] as String? ?? '') ?? DateTime.now(),
      extractedDeadline: json['extractedDeadline'] != null
          ? DateTime.tryParse(json['extractedDeadline'] as String)
          : null,
      extractedAction: json['extractedAction'] as String?,
      targetAudience: json['targetAudience'] as String?,
      source: json['source'] as String? ?? 'MANUAL',
    );
  }
}
