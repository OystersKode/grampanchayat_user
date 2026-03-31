import 'package:flutter/material.dart';
import '../../data/models/news_model.dart';

class NewsCard extends StatelessWidget {
  final News news;
  final VoidCallback onTap;

  const NewsCard({super.key, required this.news, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(news.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(news.date),
        onTap: onTap,
      ),
    );
  }
}
