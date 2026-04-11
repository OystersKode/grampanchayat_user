import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/share_utils.dart';
import '../../data/repositories/app_repository.dart';

class AnnouncementCard extends StatefulWidget {
  final String contentId;
  final String category;
  final Color? categoryColor;
  final String title;
  final String description;
  final String location;
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
    required this.description,
    required this.location,
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

  @override
  void didUpdateWidget(AnnouncementCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.likes != widget.likes || oldWidget.initialIsLiked != widget.initialIsLiked) {
      setState(() {
        _likeCount = int.tryParse(widget.likes) ?? 0;
        _isLiked = widget.initialIsLiked;
      });
    }
  }

  Future<void> _handleLike() async {
    if (_isLoading) return;

    // Optimistic Update: Update UI immediately
    final previousIsLiked = _isLiked;
    final previousLikeCount = _likeCount;

    setState(() {
      if (_isLiked) {
        _likeCount--;
        _isLiked = false;
      } else {
        _likeCount++;
        _isLiked = true;
      }
      _isLoading = true;
    });

    try {
      await AppRepository.instance.toggleLike(
        contentId: widget.contentId,
        contentType: 'news',
      );
      // Success, just clear loading state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Revert on error
      if (mounted) {
        setState(() {
          _isLiked = previousIsLiked;
          _likeCount = previousLikeCount;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _handleShare() async {
    setState(() => _isLoading = true);

    try {
      final String text = ShareUtils.formatNewsForWhatsApp(
        title: widget.title,
        description: widget.description,
      );

      if (widget.imageUrl.isNotEmpty) {
        final response = await http.get(Uri.parse(widget.imageUrl));
        final bytes = response.bodyBytes;

        final temp = await getTemporaryDirectory();
        final path = '${temp.path}/share_news_${widget.contentId}.png';
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
      Share.share('*${widget.title}*');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: widget.onTap,
            child: Stack(
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (widget.location.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.white70, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              widget.location,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        _stripMarkdown(widget.description),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFFFFF2E1),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                // LIKE BUTTON
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleLike,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            color: const Color(0xFF5E0006),
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _likeCount.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF241A06),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // SHARE BUTTON
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleShare,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.share_outlined, color: Color(0xFFBC0006), size: 22),
                          SizedBox(width: 10),
                          Text(
                            'Share',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFBC0006),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _stripMarkdown(String text) {
    // Basic regex to remove common markdown symbols for the card preview
    return text
        .replaceAll(RegExp(r'\*\*|__'), '') // Bold
        .replaceAll(RegExp(r'\*|_'), '')    // Italic
        .replaceAll(RegExp(r'#+\s'), '')    // Headers
        .replaceAll(RegExp(r'\[(.*?)\]\(.*?\)'), r'$1') // Links
        .replaceAll(RegExp(r'!\[.*?\]\(.*?\)'), '') // Images
        .trim();
  }
}
