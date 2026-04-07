import 'package:cloud_firestore/cloud_firestore.dart';

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
      createdAt: _formatDate(json['created_at']),
      likeCount: json['like_count'] ?? 0,
      isLiked: json['is_liked'] == 1 || json['is_liked'] == true,
    );
  }

  static String _formatDate(Object? value) {
    if (value == null) return '';
    
    DateTime? parsed;
    if (value is Timestamp) {
      parsed = value.toDate();
    } else if (value is String) {
      parsed = DateTime.tryParse(value);
    }

    if (parsed == null) return value.toString();

    final String day = parsed.day.toString().padLeft(2, '0');
    final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '$day ${months[parsed.month - 1]} ${parsed.year}';
  }
}
