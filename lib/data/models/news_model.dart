class News {
  final String id;
  final String title;
  final String description;
  final String headerImageUrl;
  final List<String> images;
  final String category;
  final String date;
  final int likeCount;
  final bool isLiked;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.headerImageUrl,
    required this.images,
    required this.category,
    required this.date,
    required this.likeCount,
    required this.isLiked,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawImages = (json['images'] as List<dynamic>?) ?? <dynamic>[];
    return News(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      description: (json['content'] as String?) ?? (json['description'] as String?) ?? '',
      headerImageUrl: (json['header_image_url'] as String?) ?? '',
      images: rawImages.map((dynamic item) {
        if (item is String) {
          return item;
        }
        if (item is Map<String, dynamic>) {
          return (item['image_url'] as String?) ?? '';
        }
        return '';
      }).where((String item) => item.isNotEmpty).toList(),
      category: ((json['category'] as String?) ?? 'Updates').toUpperCase(),
      date: _formatDate(json['created_at'] as String?),
      likeCount: _parseLikeCount(json['like_count']),
      isLiked: json['is_liked'] == 1 || json['is_liked'] == true,
    );
  }

  static int _parseLikeCount(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static String _formatDate(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }

    final DateTime? parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return value;
    }

    final String day = parsed.day.toString().padLeft(2, '0');
    final List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final String month = months[parsed.month - 1];
    return '$day $month ${parsed.year}';
  }
}
