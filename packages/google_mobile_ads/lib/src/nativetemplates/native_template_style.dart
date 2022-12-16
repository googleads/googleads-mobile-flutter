import 'dart:ui';

import 'package:google_mobile_ads/src/nativetemplates/template_type.dart';
import 'package:google_mobile_ads/src/nativetemplates/native_template_text_style.dart';

/// Style options for native templates.
///
/// Can be used when loading a [NativeAd].
class NativeTemplateStyle {

  /// Create a [NativeTemplateStyle].
  ///
  /// Only templateType is required.
  NativeTemplateStyle({
    required this.templateType,
    this.callToActionTextStyle,
    this.primaryTextStyle,
    this.secondaryTextStyle,
    this.tertiaryTextStyle,
    this.mainBackgroundColor,
    this.cornerRadius,
});

  /// The [TemplateType] to use.
  TemplateType templateType;

  /// The [NativeTemplateTextStyle] for the call to action.
  NativeTemplateTextStyle? callToActionTextStyle;

  /// The [NativeTemplateTextStyle] for the primary text.
  NativeTemplateTextStyle? primaryTextStyle;

  /// The [NativeTemplateTextStyle] for the second row of text in the template.
  ///
  /// All templates have a secondary text area which is populated either by the
  /// body of the ad or by the rating of the app.
  NativeTemplateTextStyle? secondaryTextStyle;

  /// The [NativeTemplateTextStyle] for the third row of text in the template.
  ///
  /// The third row is used to display store name or the default tertiary text.
  NativeTemplateTextStyle? tertiaryTextStyle;

  /// The background color.
  Color? mainBackgroundColor;

  /// The corner radius for the icon view and call to action (iOS only).
  double? cornerRadius;
}
