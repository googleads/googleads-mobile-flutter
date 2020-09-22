// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.firebaseadmob;

import android.os.Bundle;
import androidx.annotation.Nullable;
import com.google.ads.mediation.admob.AdMobAdapter;
import com.google.android.gms.ads.AdRequest;
import java.util.Date;
import java.util.List;

class FlutterAdRequest {
  @Nullable private List<String> keywords;
  @Nullable private String contentUrl;
  @Nullable private Date birthday;
  @Nullable private MobileAdGender gender;
  @Nullable private Boolean designedForFamilies;
  @Nullable private Boolean childDirected;
  @Nullable private List<String> testDevices;
  @Nullable private Boolean nonPersonalizedAds;

  enum MobileAdGender {
    UNKNOWN,
    MALE,
    FEMALE,
  }

  static class Builder {
    @Nullable private List<String> keywords;
    @Nullable private String contentUrl;
    @Nullable private Date birthday;
    @Nullable private MobileAdGender gender;
    @Nullable private Boolean designedForFamilies;
    @Nullable private Boolean childDirected;
    @Nullable private List<String> testDevices;
    @Nullable private Boolean nonPersonalizedAds;

    Builder setKeywords(@Nullable List<String> keywords) {
      this.keywords = keywords;
      return this;
    }

    Builder setContentUrl(@Nullable String contentUrl) {
      this.contentUrl = contentUrl;
      return this;
    }

    Builder setBirthday(@Nullable Date birthday) {
      this.birthday = birthday;
      return this;
    }

    Builder setGender(@Nullable MobileAdGender gender) {
      this.gender = gender;
      return this;
    }

    Builder setDesignedForFamilies(@Nullable Boolean designedForFamilies) {
      this.designedForFamilies = designedForFamilies;
      return this;
    }

    Builder setChildDirected(@Nullable Boolean childDirected) {
      this.childDirected = childDirected;
      return this;
    }

    Builder setTestDevices(@Nullable List<String> testDevices) {
      this.testDevices = testDevices;
      return this;
    }

    Builder setNonPersonalizedAds(@Nullable Boolean nonPersonalizedAds) {
      this.nonPersonalizedAds = nonPersonalizedAds;
      return this;
    }

    FlutterAdRequest build() {
      final FlutterAdRequest request = new FlutterAdRequest();
      request.keywords = keywords;
      request.contentUrl = contentUrl;
      request.birthday = birthday;
      request.gender = gender;
      request.designedForFamilies = designedForFamilies;
      request.childDirected = childDirected;
      request.testDevices = testDevices;
      request.nonPersonalizedAds = nonPersonalizedAds;
      return request;
    }
  }

  private FlutterAdRequest() {}

  AdRequest asAdRequest() {
    final AdRequest.Builder builder = new AdRequest.Builder();

    if (keywords != null) {
      for (final String keyword : keywords) {
        builder.addKeyword(keyword);
      }
    }
    if (contentUrl != null) builder.setContentUrl(contentUrl);
    if (birthday != null) builder.setBirthday(birthday);
    if (gender != null) builder.setGender(gender.ordinal());
    if (designedForFamilies != null) builder.setIsDesignedForFamilies(designedForFamilies);
    if (childDirected != null) builder.tagForChildDirectedTreatment(childDirected);
    if (testDevices != null) {
      for (final String testDevice : testDevices) {
        builder.addTestDevice(testDevice);
      }
    }
    if (nonPersonalizedAds != null && nonPersonalizedAds) {
      final Bundle extras = new Bundle();
      extras.putString("npa", "1");
      builder.addNetworkExtrasBundle(AdMobAdapter.class, extras);
    }
    builder.setRequestAgent("Flutter");
    return builder.build();
  }

  @Nullable
  public List<String> getKeywords() {
    return keywords;
  }

  @Nullable
  public String getContentUrl() {
    return contentUrl;
  }

  @Nullable
  public Date getBirthday() {
    return birthday;
  }

  @Nullable
  public MobileAdGender getGender() {
    return gender;
  }

  @Nullable
  public Boolean getDesignedForFamilies() {
    return designedForFamilies;
  }

  @Nullable
  public Boolean getChildDirected() {
    return childDirected;
  }

  @Nullable
  public List<String> getTestDevices() {
    return testDevices;
  }

  @Nullable
  public Boolean getNonPersonalizedAds() {
    return nonPersonalizedAds;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof FlutterAdRequest)) return false;

    FlutterAdRequest that = (FlutterAdRequest) o;

    if (keywords != null ? !keywords.equals(that.keywords) : that.keywords != null) return false;
    if (contentUrl != null ? !contentUrl.equals(that.contentUrl) : that.contentUrl != null)
      return false;
    if (birthday != null ? !birthday.equals(that.birthday) : that.birthday != null) return false;
    if (gender != that.gender) return false;
    if (designedForFamilies != null
        ? !designedForFamilies.equals(that.designedForFamilies)
        : that.designedForFamilies != null) return false;
    if (childDirected != null
        ? !childDirected.equals(that.childDirected)
        : that.childDirected != null) return false;
    if (testDevices != null ? !testDevices.equals(that.testDevices) : that.testDevices != null)
      return false;
    return nonPersonalizedAds != null
        ? nonPersonalizedAds.equals(that.nonPersonalizedAds)
        : that.nonPersonalizedAds == null;
  }

  @Override
  public int hashCode() {
    int result = keywords != null ? keywords.hashCode() : 0;
    result = 31 * result + (contentUrl != null ? contentUrl.hashCode() : 0);
    result = 31 * result + (birthday != null ? birthday.hashCode() : 0);
    result = 31 * result + (gender != null ? gender.hashCode() : 0);
    result = 31 * result + (designedForFamilies != null ? designedForFamilies.hashCode() : 0);
    result = 31 * result + (childDirected != null ? childDirected.hashCode() : 0);
    result = 31 * result + (testDevices != null ? testDevices.hashCode() : 0);
    result = 31 * result + (nonPersonalizedAds != null ? nonPersonalizedAds.hashCode() : 0);
    return result;
  }
}
