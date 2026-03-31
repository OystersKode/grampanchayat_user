class User {
  final String id;
  final String name;
  final String email;
  final String district;
  final String taluka;
  final String gramPanchayat;
  final String role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.district,
    required this.taluka,
    required this.gramPanchayat,
    this.role = "citizen",
    required this.createdAt,
  });
}
