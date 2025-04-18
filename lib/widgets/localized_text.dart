import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/translations.dart';

class LocalizedText extends StatelessWidget {
  final String translationKey;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final bool softWrap;
  
  const LocalizedText({
    super.key,
    required this.translationKey,
    this.style,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.softWrap = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final String translatedText = AppTranslations.getText(
      translationKey, 
      languageProvider.currentLanguageIndex
    );
    
    // Tamil-specific adjustments (index 3)
    final bool isTamil = languageProvider.currentLanguageIndex == 3;
    
    // Adjust style for Tamil
    TextStyle? adjustedStyle = style;
    if (style != null && isTamil) {
      final double fontSize = (style!.fontSize ?? 14) * 0.85; // 15% smaller for Tamil
      adjustedStyle = style!.copyWith(
        fontSize: fontSize,
        letterSpacing: -0.3, // Tighter letter spacing
        height: 1.1,        // Tighter line height
      );
    }
    
    // Determine max lines - allow one more line for Tamil if not explicitly set
    final int effectiveMaxLines = maxLines ?? (isTamil ? 3 : 2);
    
    return Text(
      translatedText,
      style: adjustedStyle,
      textAlign: textAlign,
      maxLines: effectiveMaxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}