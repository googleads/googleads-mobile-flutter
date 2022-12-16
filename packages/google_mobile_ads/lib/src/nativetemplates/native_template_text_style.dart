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
}
