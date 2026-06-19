import 'package:flutter/material.dart';
import '../../core/localization/app_translations.dart';
import '../../core/services/translation_service.dart';
import '../../core/services/settings_service.dart';

class TranslatedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    // Clean markdown escapes from the source text
    final String cleanedText = text.replaceAll(RegExp(r'\\(?=[.!@#\$%^&*()\-=_+\[\]{}|;:",./<>?])'), '');

    return ListenableBuilder(
      listenable: SettingsService.instance,
      builder: (context, _) {
        final targetLang = SettingsService.instance.languageCode;
        
        if (cleanedText.isEmpty) {
          return Text(
            cleanedText,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
          );
        }

        // 1. Check if a manual translation exists in our dictionary first
        final String manualTranslation = cleanedText.tr(context);
        if (manualTranslation != cleanedText) {
          return Text(
            manualTranslation,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
          );
        }

        // 2. Otherwise, determine if on-the-fly translation is needed
        final bool containsKannada = RegExp(r'[\u0C80-\u0CFF]').hasMatch(cleanedText);
        final bool needsTranslation = (targetLang == 'kn' && !containsKannada) || 
                                      (targetLang == 'en' && containsKannada);

        if (!needsTranslation) {
          return Text(
            cleanedText,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
          );
        }

        return FutureBuilder<String>(
          future: TranslationService.instance.translate(cleanedText, targetLang),
          initialData: cleanedText,
          builder: (context, snapshot) {
            return Text(
              snapshot.data ?? cleanedText,
              style: style,
              maxLines: maxLines,
              overflow: overflow,
              textAlign: textAlign,
            );
          },
        );
      },
    );
  }
}
