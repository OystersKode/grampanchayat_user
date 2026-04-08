import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/share_utils.dart';
import '../../data/repositories/app_repository.dart';

class LikeShareButtons extends StatefulWidget {
  final String contentId;
  final String contentType;
  final String shareText;
  final String? imageUrl;
  final int initialLikes;
  final bool initialIsLiked;

  const LikeShareButtons({
    super.key,
    required this.contentId,
    required this.contentType,
    required this.shareText,
    this.imageUrl,
    this.initialLikes = 0,
    this.initialIsLiked = false,
  });

  @override
  State<LikeShareButtons> createState() => _LikeShareButtonsState();
}

class _LikeShareButtonsState extends State<LikeShareButtons> {
  late bool _isLiked;
  late int _likeCount;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.initialLikes;
    _isLiked = widget.initialIsLiked;
  }

  Future<void> _handleLike() async {
    if (_isLoading) return;

    // Optimistic Update
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
        contentType: widget.contentType,
      );
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      // Revert on failure
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
      final String text = ShareUtils.formatForWhatsApp(widget.shareText);

      if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
        // 1. Download image
        final response = await http.get(Uri.parse(widget.imageUrl!));
        final bytes = response.bodyBytes;

        // 2. Save to temp directory
        final temp = await getTemporaryDirectory();
        final path = '${temp.path}/shared_image.png';
        File(path).writeAsBytesSync(bytes);

        // 3. Share with Image + Text
        await Share.shareXFiles(
          [XFile(path)],
          text: text,
        );
      } else {
        // Fallback to text only
        await Share.share(text);
      }
    } catch (e) {
      debugPrint('Share Error: $e');
      // Fallback
      Share.share(widget.shareText);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Increased touch target for Like button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleLike,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF5E0006),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 24, // Slightly larger icon
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _likeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Increased touch target for Share button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleShare,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF5E0006),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.share, size: 22, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    "Share",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
