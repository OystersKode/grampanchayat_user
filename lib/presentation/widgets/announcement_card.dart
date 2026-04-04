import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/repositories/app_repository.dart';

class AnnouncementCard extends StatefulWidget {
  final String contentId;
  final String category;
  final Color? categoryColor;
  final String title;
  final String kannadaTitle;
  final String imageUrl;
  final String likes;
  final bool initialIsLiked;
  final String shareUrl;
  final VoidCallback? onTap;

  const AnnouncementCard({
    super.key,
    required this.contentId,
    required this.category,
    this.categoryColor,
    required this.title,
    required this.kannadaTitle,
    required this.imageUrl,
    required this.likes,
    this.initialIsLiked = false,
    required this.shareUrl,
    this.onTap,
  });

  @override
  State<AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
  late int _likeCount;
  bool _isLiked = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _likeCount = int.tryParse(widget.likes) ?? 0;
    _isLiked = widget.initialIsLiked;
  }

  Future<void> _handleLike() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AppRepository.instance.toggleLike(
        contentId: widget.contentId,
        contentType: 'news',
      );

      if (success) {
        setState(() {
          if (_isLiked) {
            _likeCount--;
            _isLiked = false;
          } else {
            _likeCount++;
            _isLiked = true;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleShare() {
    Share.share(
      'Check out this news from Kagwad Panchayat: ${widget.title}\n\n'
      'View more: ${widget.shareUrl}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF241A06).withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.imageUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 240,
                    color: const Color(0xFFF5E0BF),
                    child: const Icon(Icons.image_not_supported_outlined, size: 48),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.categoryColor ?? const Color(0xFFBC0006),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.kannadaTitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              color: const Color(0xFFFFF2E1),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _handleLike,
                    child: Row(
                      children: [
                        Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: const Color(0xFF5E0006),
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _likeCount.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF241A06),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  GestureDetector(
                    onTap: _handleShare,
                    child: Row(
                      children: [
                        const Icon(Icons.share_outlined, color: Color(0xFFBC0006), size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Share',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBC0006),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
