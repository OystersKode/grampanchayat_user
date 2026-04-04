class Wish {
  final String id;
  final String title;
  final String content;
  final String tag;
  final String headerImageUrl;
  final String createdAt;
  final int likeCount;
  final bool isLiked;

  Wish({
    required this.id,
    required this.title,
    required this.content,
    required this.tag,
    required this.headerImageUrl,
    required this.createdAt,
    this.likeCount = 0,
    this.isLiked = false,
  });

  factory Wish.fromJson(Map<String, dynamic> json) {
    return Wish(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      tag: json['tag'] ?? 'General',
      headerImageUrl: json['header_image_url'] ?? '',
      createdAt: json['created_at'] ?? '',
      likeCount: json['like_count'] ?? 0,
      isLiked: json['is_liked'] == 1 || json['is_liked'] == true,
    );
  }
}
