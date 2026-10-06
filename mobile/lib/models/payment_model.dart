class PaymentModel {
  final String id;
  final String jenis;
  final int nominal;
  final DateTime jatuhTempo;
  final String status; // LUNAS, BELUM_LUNAS

  const PaymentModel({
    required this.id,
    required this.jenis,
    required this.nominal,
    required this.jatuhTempo,
    required this.status,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String? ?? '',
      jenis: json['jenis'] as String? ?? '',
      nominal: json['nominal'] as int? ?? 0,
      jatuhTempo: DateTime.tryParse(json['jatuhTempo'] as String? ?? '') ?? DateTime.now(),
      status: json['status'] as String? ?? 'BELUM_LUNAS',
    );
  }
}
