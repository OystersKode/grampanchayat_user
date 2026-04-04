import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../data/models/news_model.dart';
import '../../../data/repositories/app_repository.dart';
import '../../widgets/like_share_buttons.dart';

class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen({super.key, this.news});

  final News? news;

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  late Future<News> _detailsFuture;

  @override
  void initState() {
    super.initState();
    final News? initial = widget.news;
    if (initial == null || initial.id.isEmpty) {
      _detailsFuture = Future<News>.error(Exception('Invalid news item'));
    } else {
      _detailsFuture = AppRepository.instance.getNewsDetails(initial.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E0006),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'News Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<News>(
        future: _detailsFuture,
        builder: (BuildContext context, AsyncSnapshot<News> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to load details.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final News item = snapshot.data!;
          final String heroImage = item.headerImageUrl.isNotEmpty
              ? item.headerImageUrl
              : (item.images.isNotEmpty ? item.images.first : '');

          return ListView(
            children: [
              if (heroImage.isNotEmpty)
                Image.network(
                  heroImage,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Container(
                      height: 260,
                      color: const Color(0xFFF5E0BF),
                      child: const Icon(Icons.image_not_supported_outlined, size: 48),
                    );
                  },
                )
              else
                Container(
                  height: 260,
                  color: const Color(0xFFF5E0BF),
                  child: const Icon(Icons.image_not_supported_outlined, size: 48),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category,
                      style: const TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF653D1E),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF370002),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Color(0xFF653D1E)),
                        const SizedBox(width: 8),
                        Text(item.date),
                      ],
                    ),
                    const SizedBox(height: 20),
                    LikeShareButtons(
                      contentId: item.id,
                      contentType: 'news',
                      shareText: '*${item.title}*\n\n'
                          '${item.description.length > 200 ? item.description.substring(0, 200) + "..." : item.description}\n\n'
                          '📍 *Village Details:* Kagwad Gram Panchayat',
                      imageUrl: heroImage,
                      initialLikes: item.likeCount,
                      initialIsLiked: item.isLiked,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Color(0xFF57413F),
                      ),
                    ),
                    if (item.images.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Related Images',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 160,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: item.images.map((String url) {
                            return _buildRelatedImage(url);
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRelatedImage(String url) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 240,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return Container(
            color: const Color(0xFFF5E0BF),
            child: const Icon(Icons.image_not_supported_outlined),
          );
        },
      ),
    );
  }
}
