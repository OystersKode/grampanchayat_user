import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../../core/services/settings_service.dart';
import '../../../data/models/wish_model.dart';
import '../../../data/repositories/app_repository.dart';
import '../../widgets/like_share_buttons.dart';
import '../../widgets/sidebar.dart';
import 'package:share_plus/share_plus.dart';

class WishesScreen extends StatefulWidget {
  const WishesScreen({super.key});

  @override
  State<WishesScreen> createState() => _WishesScreenState();
}

class _WishesScreenState extends State<WishesScreen> {
  late Future<List<Wish>> _wishesFuture;

  @override
  void initState() {
    super.initState();
    _wishesFuture = AppRepository.instance.getWishes();
  }

  Future<void> _refreshWishes() async {
    setState(() {
      _wishesFuture = AppRepository.instance.getWishes();
    });
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
          'Village Wishes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
              onPressed: () {
                // Placeholder
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: const Text(
                'EN/ಕನ್ನಡ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppSidebar(),
      body: RefreshIndicator(
        onRefresh: _refreshWishes,
        child: FutureBuilder<List<Wish>>(
          future: _wishesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            final wishes = snapshot.data ?? [];
            if (wishes.isEmpty) {
              return const Center(
                child: Text('No wishes yet. Check back later!'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: wishes.length + 1, // +1 for the header
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COMMUNITY SPIRIT',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF653D1E),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Village Wishes',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF241A06),
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Celebrating the milestones, festivals, and achievements that bind Kagwad together.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF653D1E),
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  );
                }
                final wish = wishes[index - 1];
                return WishCard(wish: wish);
              },
            );
          },
        ),
      ),
    );
  }
}

class WishCard extends StatefulWidget {
  final Wish wish;

  const WishCard({
    super.key,
    required this.wish,
  });

  @override
  State<WishCard> createState() => _WishCardState();
}

class _WishCardState extends State<WishCard> {
  bool _isSharing = false;

  Future<void> _handleShare() async {
    setState(() => _isSharing = true);

    try {
      final String text = '*${widget.wish.title}*\n\n${widget.wish.content}\n\n'
          '✨ *From:* Kagwad Gram Panchayat';

      if (widget.wish.headerImageUrl.isNotEmpty) {
        final response = await http.get(Uri.parse(widget.wish.headerImageUrl));
        final bytes = response.bodyBytes;

        final temp = await getTemporaryDirectory();
        final path = '${temp.path}/wish_share.png';
        File(path).writeAsBytesSync(bytes);

        await Share.shareXFiles(
          [XFile(path)],
          text: text,
        );
      } else {
        await Share.share(text);
      }
    } catch (e) {
      debugPrint('Share Error: $e');
      Share.share('*${widget.wish.title}*\n\n${widget.wish.content}');
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.wish.headerImageUrl.isNotEmpty)
            Image.network(
              widget.wish.headerImageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Color(0xFFBC0006),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.wish.tag.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Color(0xFFBC0006),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.wish.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF370002),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.wish.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF653D1E),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                LikeShareButtons(
                  contentId: widget.wish.id,
                  contentType: 'wish',
                  shareText: '*${widget.wish.title}*\n\n${widget.wish.content}\n\n'
                      '✨ *From:* Kagwad Gram Panchayat',
                  imageUrl: widget.wish.headerImageUrl,
                  initialLikes: widget.wish.likeCount,
                  initialIsLiked: widget.wish.isLiked,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
