import 'package:translator/translator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TranslationService {
  TranslationService._();
  static final TranslationService instance = TranslationService._();
  
  final _translator = GoogleTranslator();
  final String _cacheKey = 'translation_cache';
  Map<String, String> _cache = {};

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      _cache = Map<String, String>.from(json.decode(cachedData));
    }
  }

  Future<String> translate(String text, String targetLanguage) async {
    if (text.isEmpty) return text;
    
    // Check if text contains Kannada characters
    bool containsKannada = RegExp(r'[\u0C80-\u0CFF]').hasMatch(text);
    
    // If target is English and text is already English (no Kannada chars), skip translation
    if (targetLanguage == 'en' && !containsKannada) return text;
    
    // If target is Kannada and text is already Kannada (has Kannada chars), skip translation
    if (targetLanguage == 'kn' && containsKannada) return text;

    // Special case: If text contains BOTH English and Kannada, we might still want to translate it
    // But for most common cases (data from admin), it's usually one or the other.

    final key = '${targetLanguage}_$text';
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    try {
      final translation = await _translator.translate(text, to: targetLanguage);
      String translatedText = translation.text;
      
      // Validation: If target is Kannada, result should have Kannada chars
      bool containsKannada = RegExp(r'[\u0C80-\u0CFF]').hasMatch(translatedText);
      bool isSuccessful = (targetLanguage == 'kn' && containsKannada) || 
                          (targetLanguage == 'en' && !containsKannada);

      // Fallback for names or complex strings: Try word-by-word if full translation stayed in source script
      if (!isSuccessful && text.contains(' ')) {
        final words = text.split(' ');
        final List<String> translatedWords = [];
        
        for (final word in words) {
          if (word.isEmpty) {
            translatedWords.add('');
            continue;
          }
          // Try to translate each word, if it fails, keep the word
          try {
            final t = await _translator.translate(word, to: targetLanguage);
            translatedWords.add(t.text);
          } catch (_) {
            translatedWords.add(word);
          }
        }
        
        translatedText = translatedWords.join(' ');
        containsKannada = RegExp(r'[\u0C80-\u0CFF]').hasMatch(translatedText);
        isSuccessful = (targetLanguage == 'kn' && containsKannada) || 
                       (targetLanguage == 'en' && !containsKannada);
      }

      if (isSuccessful) {
        _cache[key] = translatedText;
        await _saveCache();
        return translatedText;
      }
      
      return translatedText; // Return what we got even if not perfect, but don't cache
    } catch (e) {
      print('Translation error: $e');
      return text;
    }
  }

  Future<void> _saveCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, json.encode(_cache));
  }
}
