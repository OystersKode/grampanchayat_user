import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    // Priority 1: cover_image_url (from recent database entry)
    // Priority 2: header_image_url (previous version)
    final String headerImg = (json['cover_image_url'] as String?) ?? 
                             (json['header_image_url'] as String?) ?? '';

    // Priority 1: related_images (from recent database entry)
    // Priority 2: related_image_urls (from Admin App)
    // Priority 3: images (from legacy/subcollection implementation)
    final List<dynamic> rawImages = (json['related_images'] as List<dynamic>?) ?? 
                                   (json['related_image_urls'] as List<dynamic>?) ?? 
                                   (json['images'] as List<dynamic>?) ?? 
                                   <dynamic>[];
    
    // Get the category string
    final String categoryStr = (json['category'] as String?) ?? 'Updates';

    return News(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      description: (json['content'] as String?) ?? (json['description'] as String?) ?? '',
      headerImageUrl: headerImg,
      images: rawImages.map((dynamic item) {
        if (item is String) {
          return item;
        }
        if (item is Map<String, dynamic>) {
          return (item['image_url'] as String?) ?? '';
        }
        return '';
      }).where((String item) => item.isNotEmpty).toList(),
      category: categoryStr.toUpperCase(),
      date: _formatDate(json['created_at']),
      likeCount: _parseLikeCount(json['like_count']),
      isLiked: json['is_liked'] == 1 || json['is_liked'] == true,
    );
  }

  // Helper to get color based on category name
  Color get categoryColor {
    final String cat = category.toLowerCase();
    if (cat.contains('health') || cat.contains('ಆರೋಗ್ಯ')) return const Color(0xFF2E7D32); // Green
    if (cat.contains('agri') || cat.contains('ಕೃಷಿ')) return const Color(0xFFEF6C00); // Orange
    if (cat.contains('road') || cat.contains('ರಸ್ತೆ') || cat.contains('infra')) return const Color(0xFF1565C0); // Blue
    if (cat.contains('edu') || cat.contains('ಶಿಕ್ಷಣ')) return const Color(0xFF6A1B9A); // Purple
    if (cat.contains('fest') || cat.contains('ಹಬ್ಬ')) return const Color(0xFFC62828); // Red
    return const Color(0xFFBC0006); // Default Deep Red
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

  static String _formatDate(Object? value) {
    if (value == null) {
      return '';
    }

    DateTime? parsed;
    if (value is Timestamp) {
      parsed = value.toDate();
    } else if (value is String) {
      parsed = DateTime.tryParse(value);
    }

    if (parsed == null) {
      return value.toString();
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
