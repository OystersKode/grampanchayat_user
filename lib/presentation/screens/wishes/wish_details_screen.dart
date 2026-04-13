import 'package:flutter/material.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/utils/share_utils.dart';
import '../../../data/models/wish_model.dart';
import '../../widgets/like_share_buttons.dart';
import '../../widgets/translated_text.dart';

class WishDetailsScreen extends StatelessWidget {
  final Wish wish;

  const WishDetailsScreen({super.key, required this.wish});

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
        title: Text(
          'wish_details'.tr(context),
          style: const TextStyle(
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
                SettingsService.instance.toggleLanguage();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: ListenableBuilder(
                listenable: SettingsService.instance,
                builder: (context, _) {
                  return Text(
                    SettingsService.instance.languageCode == 'en' ? 'ಕನ್ನಡ' : 'English',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          if (wish.headerImageUrl.isNotEmpty)
            Image.network(
              wish.headerImageUrl,
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
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Color(0xFFBC0006),
                    ),
                    const SizedBox(width: 8),
                    TranslatedText(
                      wish.tag.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFBC0006),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TranslatedText(
                  wish.title,
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
                    Text(wish.createdAt),
                  ],
                ),
                const SizedBox(height: 20),
                LikeShareButtons(
                  contentId: wish.id,
                  contentType: 'wishes',
                  shareText: ShareUtils.formatWishForWhatsApp(
                    title: wish.title,
                    content: wish.content,
                  ),
                  imageUrl: wish.headerImageUrl,
                  initialLikes: wish.likeCount,
                  initialIsLiked: wish.isLiked,
                ),
                const SizedBox(height: 20),
                TranslatedText(
                  wish.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF57413F),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
