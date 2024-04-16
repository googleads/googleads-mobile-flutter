// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package io.flutter.plugins.googlemobileads.mediation.gma_mediation_inmobi

import android.os.Bundle
import android.util.Log
import android.util.Pair
import androidx.core.os.bundleOf
import com.google.ads.mediation.inmobi.InMobiAdapter
import com.google.ads.mediation.inmobi.InMobiNetworkKeys
import com.google.ads.mediation.inmobi.InMobiNetworkValues
import com.google.android.gms.ads.mediation.MediationExtrasReceiver
import io.flutter.plugins.googlemobileads.FlutterMediationExtras

class InMobiFlutterMediationExtras : FlutterMediationExtras() {
  private var flutterExtras: Map<String, Any>? = null

  override fun setMediationExtras(extras: MutableMap<String, Any>) {
    flutterExtras = extras
  }

  override fun getMediationExtras(): Pair<Class<out MediationExtrasReceiver>, Bundle> {
    val extrasMap = flutterExtras
    if (extrasMap == null) {
      return Pair<Class<out MediationExtrasReceiver>, Bundle>(InMobiAdapter::class.java, bundleOf())
    }
    val extrasBundle = bundleOf()
    val ageGroupValue = extrasMap[AGE_GROUP]
    if (ageGroupValue is Int) {
      Log.d("InMobiMediationExtras", "ageGroup: $ageGroupValue")
      when(ageGroupValue) {
        0 -> extrasBundle.putString(InMobiNetworkKeys.AGE_GROUP, InMobiNetworkValues.BELOW_18)
        1 -> extrasBundle.putString(InMobiNetworkKeys.AGE_GROUP, InMobiNetworkValues.BETWEEN_18_AND_24)
        2 -> extrasBundle.putString(InMobiNetworkKeys.AGE_GROUP, InMobiNetworkValues.BETWEEN_25_AND_29)
        3 -> extrasBundle.putString(InMobiNetworkKeys.AGE_GROUP, InMobiNetworkValues.BETWEEN_30_AND_34)
        4 -> extrasBundle.putString(InMobiNetworkKeys.AGE_GROUP, InMobiNetworkValues.BETWEEN_35_AND_44)
        5 -> extrasBundle.putString(InMobiNetworkKeys.AGE_GROUP, InMobiNetworkValues.BETWEEN_45_AND_54)
        6 -> extrasBundle.putString(InMobiNetworkKeys.AGE_GROUP, InMobiNetworkValues.BETWEEN_55_AND_65)
        7 -> extrasBundle.putString(InMobiNetworkKeys.AGE_GROUP, InMobiNetworkValues.ABOVE_65)
      }
    }
    val educationValue = extrasMap[EDUCATION]
    if (educationValue is Int) {
      Log.d("InMobiMediationExtras", "education: $educationValue")
      when (educationValue) {
        0 -> extrasBundle.putString(InMobiNetworkKeys.EDUCATION, InMobiNetworkValues.EDUCATION_HIGHSCHOOLORLESS)
        1 -> extrasBundle.putString(InMobiNetworkKeys.EDUCATION, InMobiNetworkValues.EDUCATION_COLLEGEORGRADUATE)
        2 -> extrasBundle.putString(InMobiNetworkKeys.EDUCATION, InMobiNetworkValues.EDUCATION_POSTGRADUATEORABOVE)
      }
    }
    val ageValue = extrasMap[AGE]
    if (ageValue is Int) {
      Log.d("InMobiMediationExtras", "age: $ageValue")
      extrasBundle.putString(InMobiNetworkKeys.AGE, ageValue.toString())
    }
    val postalCodeValue = extrasMap[POSTAL_CODE]
    if (postalCodeValue is String) {
      Log.d("InMobiMediationExtras", "postalCode: $postalCodeValue")
      extrasBundle.putString(InMobiNetworkKeys.POSTAL_CODE, postalCodeValue)
    }
    val areaCodeValue = extrasMap[AREA_CODE]
    if (areaCodeValue is String) {
      Log.d("InMobiMediationExtras", "areaCode: $areaCodeValue")
      extrasBundle.putString(InMobiNetworkKeys.AREA_CODE, areaCodeValue)
    }
    val languageValue = extrasMap[LANGUAGE]
    if (languageValue is String) {
      Log.d("InMobiMediationExtras", "language: $languageValue")
      extrasBundle.putString(InMobiNetworkKeys.LANGUAGE, languageValue)
    }
    val cityValue = extrasMap[CITY]
    if (cityValue is String) {
      Log.d("InMobiMediationExtras", "city: $cityValue")
      extrasBundle.putString(InMobiNetworkKeys.CITY, cityValue)
    }
    val stateValue = extrasMap[STATE]
    if (stateValue is String) {
      Log.d("InMobiMediationExtras", "state: $stateValue")
      extrasBundle.putString(InMobiNetworkKeys.STATE, stateValue)
    }
    val countryValue = extrasMap[COUNTRY]
    if (countryValue is String) {
      Log.d("InMobiMediationExtras", "country: $countryValue")
      extrasBundle.putString(InMobiNetworkKeys.COUNTRY, countryValue)
    }
    val logLevelValue = extrasMap[LOGLEVEL]
    if (logLevelValue is Int) {
      Log.d("InMobiMediationExtras", "logLevel: $logLevelValue")
      when (logLevelValue) {
        0 -> extrasBundle.putString(InMobiNetworkKeys.LOGLEVEL, InMobiNetworkValues.LOGLEVEL_NONE)
        1 -> extrasBundle.putString(InMobiNetworkKeys.LOGLEVEL, InMobiNetworkValues.LOGLEVEL_DEBUG)
        2 -> extrasBundle.putString(InMobiNetworkKeys.LOGLEVEL, InMobiNetworkValues.LOGLEVEL_ERROR)
      }
    }
    val interestsValue = extrasMap[INTERESTS]
    if (interestsValue is String) {
      Log.d("InMobiMediationExtras", "interests: $interestsValue")
      extrasBundle.putString(InMobiNetworkKeys.INTERESTS, interestsValue)
    }
    return Pair<Class<out MediationExtrasReceiver>, Bundle>(InMobiAdapter::class.java, extrasBundle)
  }

  companion object {
    private const val AGE_GROUP = "ageGroup"
    private const val EDUCATION = "education"
    private const val AGE = "age"
    private const val POSTAL_CODE = "postalCode"
    private const val AREA_CODE = "areaCode"
    private const val LANGUAGE = "language"
    private const val CITY = "city"
    private const val STATE = "state"
    private const val COUNTRY = "country"
    private const val INTERESTS = "interests"
    private const val LOGLEVEL = "logLevel"
  }
}