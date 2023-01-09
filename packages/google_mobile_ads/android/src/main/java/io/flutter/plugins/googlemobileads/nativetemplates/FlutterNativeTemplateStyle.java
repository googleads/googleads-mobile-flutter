package io.flutter.plugins.googlemobileads.nativetemplates;

import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.ads.nativetemplates.NativeTemplateStyle;
import com.google.android.ads.nativetemplates.TemplateView;

public final class FlutterNativeTemplateStyle {

  @NonNull final FlutterNativeTemplateType templateType;
  @Nullable final ColorDrawable mainBackgroundColor;
  @Nullable final FlutterNativeTemplateTextStyle callToActionStyle;
  @Nullable final FlutterNativeTemplateTextStyle primaryTextStyle;
  @Nullable final FlutterNativeTemplateTextStyle secondaryTextStyle;
  @Nullable final FlutterNativeTemplateTextStyle tertiaryTextStyle;

  public FlutterNativeTemplateStyle(
      @NonNull FlutterNativeTemplateType templateType,
      @Nullable ColorDrawable mainBackgroundColor,
      @Nullable FlutterNativeTemplateTextStyle callToActionStyle,
      @Nullable FlutterNativeTemplateTextStyle primaryTextStyle,
      @Nullable FlutterNativeTemplateTextStyle secondaryTextStyle,
      @Nullable FlutterNativeTemplateTextStyle tertiaryTextStyle) {
    this.templateType = templateType;
    this.mainBackgroundColor = mainBackgroundColor;
    this.callToActionStyle = callToActionStyle;
    this.primaryTextStyle = primaryTextStyle;
    this.secondaryTextStyle = secondaryTextStyle;
    this.tertiaryTextStyle = tertiaryTextStyle;
  }

  public NativeTemplateStyle asNativeTemplateStyle() {
    NativeTemplateStyle.Builder builder = new NativeTemplateStyle.Builder();
    if (mainBackgroundColor != null) {
      builder.withMainBackgroundColor(mainBackgroundColor);
    }
    if (callToActionStyle != null) {
      if (callToActionStyle.getBackgroundColor() != null) {
        builder.withCallToActionBackgroundColor(callToActionStyle.getBackgroundColor());
      }
      if (callToActionStyle.getTextColor() != null) {
        builder.withCallToActionTypefaceColor(callToActionStyle.getTextColor().getColor());
      }
      if (callToActionStyle.getFontStyle() != null) {
        builder.withCallToActionTextTypeface(callToActionStyle.getFontStyle().getTypeface());
      }
      if (callToActionStyle.getSize() != null) {
        builder.withCallToActionTextSize(callToActionStyle.getSize());
      }
    }
    if (primaryTextStyle != null) {
      if (primaryTextStyle.getBackgroundColor() != null) {
        builder.withPrimaryTextBackgroundColor(primaryTextStyle.getBackgroundColor());
      }
      if (primaryTextStyle.getTextColor() != null) {
        builder.withPrimaryTextTypefaceColor(primaryTextStyle.getTextColor().getColor());
      }
      if (primaryTextStyle.getFontStyle() != null) {
        builder.withPrimaryTextTypeface(primaryTextStyle.getFontStyle().getTypeface());
      }
      if (primaryTextStyle.getSize() != null) {
        builder.withPrimaryTextSize(primaryTextStyle.getSize());
      }
    }
    if (secondaryTextStyle != null) {
      if (secondaryTextStyle.getBackgroundColor() != null) {
        builder.withSecondaryTextBackgroundColor(secondaryTextStyle.getBackgroundColor());
      }
      if (secondaryTextStyle.getTextColor() != null) {
        builder.withSecondaryTextTypefaceColor(secondaryTextStyle.getTextColor().getColor());
      }
      if (secondaryTextStyle.getFontStyle() != null) {
        builder.withSecondaryTextTypeface(secondaryTextStyle.getFontStyle().getTypeface());
      }
      if (secondaryTextStyle.getSize() != null) {
        builder.withSecondaryTextSize(secondaryTextStyle.getSize());
      }
    }
    if (tertiaryTextStyle != null) {
      if (tertiaryTextStyle.getBackgroundColor() != null) {
        builder.withTertiaryTextBackgroundColor(tertiaryTextStyle.getBackgroundColor());
      }
      if (tertiaryTextStyle.getTextColor() != null) {
        builder.withTertiaryTextTypefaceColor(tertiaryTextStyle.getTextColor().getColor());
      }
      if (tertiaryTextStyle.getFontStyle() != null) {
        builder.withTertiaryTextTypeface(tertiaryTextStyle.getFontStyle().getTypeface());
      }
      if (tertiaryTextStyle.getSize() != null) {
        builder.withTertiaryTextSize(tertiaryTextStyle.getSize());
      }
    }
    return builder.build();
  }

  public TemplateView asTemplateView(Context context) {
    LayoutInflater layoutInflater =
        (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    TemplateView templateView =
        (TemplateView) layoutInflater.inflate(templateType.resourceId(), null);
    templateView.setStyles(asNativeTemplateStyle());
    return templateView;
  }
}
