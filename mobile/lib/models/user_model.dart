class UserModel {
  final String id;
  final String nim;
  final String nama;
  final String role;

  const UserModel({
    required this.id,
    required this.nim,
    required this.nama,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      nim: json['nim'] as String? ?? '',
      nama: json['nama'] as String? ?? '',
      role: json['role'] as String? ?? 'MAHASISWA',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nim': nim,
    'nama': nama,
    'role': role,
  };
}
