import '../config/app_config.dart';

class ShareUtils {
  static String formatForWhatsApp(String text) {
    if (text.isEmpty) return '';
    
    // Order matters here to avoid double-processing.
    return text
        .replaceAll(RegExp(r'(\*\*|__)'), '§') // Temporary marker for bold
        .replaceAll(RegExp(r'(\*|_)'), '_')     // Turn all single markers to italic (_)
        .replaceAll(RegExp(r'§'), '*')          // Turn markers back to bold (*)
        .replaceAll(RegExp(r'#+\s'), '')        // Remove Headers: ### Header -> Header
        .replaceAll(RegExp(r'\[(.*?)\]\((.*?)\)'), r'$1 ($2)') // Links: [text](url) -> text (url)
        .replaceAll(RegExp(r'!\[.*?\]\(.*?\)'), '')     // Remove Images: ![alt](url) -> ""
        .trim();
  }

  static String formatNewsForWhatsApp({
    required String id,
    required String title,
  }) {
    final String formattedTitle = '*${title.trim()}*';
    final String link = '${AppConfig.shareBaseUrl}/news/$id';
    
    return '$formattedTitle\n\n'
           'Read more at: $link\n\n'
           '📍 *Village Details:* Kagwad Gram Panchayat';
  }

  static String formatWishForWhatsApp({
    required String id,
    required String title,
  }) {
    final String formattedTitle = '*${title.trim()}*';
    final String link = '${AppConfig.shareBaseUrl}/wishes/$id';
    
    return '$formattedTitle\n\n'
           'View here: $link\n\n'
           '✨ *From:* Kagwad Gram Panchayat';
  }
}
