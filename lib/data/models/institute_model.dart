class Institute {
  final String id;
  final String name;
  final String imageUrl;
  final String contactNumber;
  final String email;
  final String website;

  Institute({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.contactNumber,
    required this.email,
    required this.website,
  });

  factory Institute.fromJson(Map<String, dynamic> json) {
    return Institute(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
    );
  }
}
