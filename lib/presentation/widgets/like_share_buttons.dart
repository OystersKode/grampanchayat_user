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
  late int _likeCount;
  bool _isLiked = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.initialLikes;
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
        contentType: widget.contentType,
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
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5E0006),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: _handleLike,
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            size: 20,
          ),
          label: Text(_likeCount.toString()),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5E0006),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: _handleShare,
          icon: const Icon(Icons.share, size: 20),
          label: const Text("Share"),
        ),
      ],
    );
  }
}
