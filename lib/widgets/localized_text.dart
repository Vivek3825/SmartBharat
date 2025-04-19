import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/translations.dart';

class LocalizedText extends StatelessWidget {
  final String translationKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool adaptSize;
  final TextOverflow? overflow;

  const LocalizedText({
    Key? key,
    required this.translationKey,
    this.style,
    this.textAlign,
    this.maxLines,
    this.adaptSize = false,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final text = AppTranslations.getText(translationKey, languageProvider.currentLanguageIndex);
    
    // Calculate appropriate text size
    double? fontSize = style?.fontSize;
    if (adaptSize && fontSize != null) {
      // Special handling for Tamil (index 3)
      if (languageProvider.currentLanguageIndex == 3) {
        fontSize = fontSize * 0.75; // More aggressive reduction for Tamil
      }
      // Reduce size for other languages too when adaptSize is true
      else if (text.length > 20) {
        fontSize = fontSize * 0.9;
      }
    }
    
    // Create adjusted style with the possibly new font size
    TextStyle? adjustedStyle;
    if (fontSize != null && style != null) {
      adjustedStyle = style!.copyWith(fontSize: fontSize);
    } else {
      adjustedStyle = style;
    }
    
    return Text(
      text,
      style: adjustedStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip),
    );
  }
}