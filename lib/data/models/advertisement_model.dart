class Advertisement {
  final String id;
  final String imageUrl;
  final String title;
  final String description;

  Advertisement({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'] ?? '',
      imageUrl: json['image_url'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
