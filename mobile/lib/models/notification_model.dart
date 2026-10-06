class NotificationModel {
  final String id;
  final String? eventId;
  final String tipe;
  final String prioritas; // URGENT, HIGH, MEDIUM, LOW
  final String source; // RULE, LLM
  final String judul;
  final String pesan;
  final Map<String, dynamic>? payload;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    this.eventId,
    required this.tipe,
    required this.prioritas,
    required this.source,
    required this.judul,
    required this.pesan,
    this.payload,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      eventId: json['eventId'] as String?,
      tipe: json['tipe'] as String? ?? '',
      prioritas: json['prioritas'] as String? ?? 'MEDIUM',
      source: json['source'] as String? ?? 'RULE',
      judul: json['judul'] as String? ?? '',
      pesan: json['pesan'] as String? ?? '',
      payload: json['payload'] as Map<String, dynamic>?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
