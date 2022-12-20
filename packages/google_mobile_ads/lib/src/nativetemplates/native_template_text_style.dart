import 'dart:ui';
import 'package:google_mobile_ads/src/nativetemplates/native_template_font_style.dart';

/// Text style options for native templates.
class NativeTemplateTextStyle {
  /// Create a [NativeTemplateTextStyle].
  NativeTemplateTextStyle({
    this.textColor,
    this.backgroundColor,
    this.style,
    this.size,
  });

  /// Text color
  Color? textColor;

  /// Background color
  Color? backgroundColor;

  /// FontStyle] for the text
  NativeTemplateFontStyle? style;

  /// Size of the text
  double? size;

  @override
  bool operator ==(Object other) {
    return other is NativeTemplateTextStyle &&
        textColor == other.textColor &&
        backgroundColor == other.backgroundColor &&
        style == other.style &&
        size == other.size;
  }

  @override
  int get hashCode => Object.hashAll([textColor, backgroundColor, style, size]);
}
