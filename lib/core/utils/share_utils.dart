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
    required String title,
    required String description,
  }) {
    final String formattedTitle = '*${title.trim()}*';
    final String formattedDescription = formatForWhatsApp(description);
    
    final String truncatedDescription = formattedDescription.length > 300 
        ? '${formattedDescription.substring(0, 300)}...' 
        : formattedDescription;
    
    return '$formattedTitle\n\n'
           '$truncatedDescription\n\n'
           '📍 *Village Details:* Kagwad Gram Panchayat';
  }

  static String formatWishForWhatsApp({
    required String title,
    required String content,
  }) {
    final String formattedTitle = '*${title.trim()}*';
    final String formattedContent = formatForWhatsApp(content);
    
    final String truncatedContent = formattedContent.length > 500 
        ? '${formattedContent.substring(0, 500)}...'
        : formattedContent;
    
    return '$formattedTitle\n\n'
           '$truncatedContent\n\n'
           '✨ *From:* Kagwad Gram Panchayat';
  }
}
