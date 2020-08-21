package io.flutter.plugins.firebaseadmob;

import android.os.Bundle;
import androidx.annotation.NonNull;
import com.google.ads.mediation.admob.AdMobAdapter;
import com.google.android.gms.ads.AdRequest;
import java.util.Date;
import java.util.List;

class FlutterAdRequest {
  @NonNull final List<String> keywords;
  final String contentUrl;
  final Date birthday;
  final MobileAdGender gender;
  final Boolean designedForFamilies;
  final Boolean childDirected;
  @NonNull final List<String> testDevices;
  final Boolean nonPersonalizedAds;

  enum MobileAdGender {
    UNKNOWN,
    MALE,
    FEMALE,
  }

  FlutterAdRequest(
      @NonNull List<String> keywords,
      String contentUrl,
      Date birthday,
      MobileAdGender gender,
      Boolean designedForFamilies,
      Boolean childDirected,
      @NonNull List<String> testDevices,
      Boolean nonPersonalizedAds) {
    this.keywords = keywords;
    this.contentUrl = contentUrl;
    this.birthday = birthday;
    this.gender = gender;
    this.designedForFamilies = designedForFamilies;
    this.childDirected = childDirected;
    this.testDevices = testDevices;
    this.nonPersonalizedAds = nonPersonalizedAds;
  }

  AdRequest asAdRequest() {
    final AdRequest.Builder builder = new AdRequest.Builder();
    for (final String keyword : keywords) {
      builder.addKeyword(keyword);
    }
    builder.setContentUrl(contentUrl);
    builder.setBirthday(birthday);
    if (gender != null) builder.setGender(gender.ordinal());
    if (designedForFamilies != null) builder.setIsDesignedForFamilies(designedForFamilies);
    if (childDirected != null) builder.tagForChildDirectedTreatment(childDirected);
    for (final String testDevice : testDevices) {
      builder.addTestDevice(testDevice);
    }
    if (nonPersonalizedAds != null && nonPersonalizedAds) {
      final Bundle extras = new Bundle();
      extras.putString("npa", "1");
      builder.addNetworkExtrasBundle(AdMobAdapter.class, extras);
    }
    builder.setRequestAgent("Flutter");
    return builder.build();
  }

  // Object.equals requires API 19+.
  @SuppressWarnings("EqualsReplaceableByObjectsCall")
  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof FlutterAdRequest)) return false;

    final FlutterAdRequest that = (FlutterAdRequest) o;

    if (designedForFamilies != that.designedForFamilies) return false;
    if (childDirected != that.childDirected) return false;
    if (nonPersonalizedAds != that.nonPersonalizedAds) return false;
    if (!keywords.equals(that.keywords)) return false;
    if (contentUrl != null ? !contentUrl.equals(that.contentUrl) : that.contentUrl != null)
      return false;
    if (birthday != null ? !birthday.equals(that.birthday) : that.birthday != null) return false;
    if (gender != that.gender) return false;
    return testDevices.equals(that.testDevices);
  }

  @Override
  public int hashCode() {
    int result = keywords.hashCode();
    result = 31 * result + (contentUrl != null ? contentUrl.hashCode() : 0);
    result = 31 * result + (birthday != null ? birthday.hashCode() : 0);
    result = 31 * result + (gender != null ? gender.hashCode() : 0);
    result = 31 * result + (designedForFamilies ? 1 : 0);
    result = 31 * result + (childDirected ? 1 : 0);
    result = 31 * result + testDevices.hashCode();
    result = 31 * result + (nonPersonalizedAds ? 1 : 0);
    return result;
  }
}
