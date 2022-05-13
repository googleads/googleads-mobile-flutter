// Copyright 2022 Google LLC
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

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/src/ump/consent_information_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:google_mobile_ads/src/ump/user_messaging_channel.dart';

import 'user_messaging_platform_test.mocks.dart';

@GenerateMocks([UserMessagingChannel])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserMessagingPlatform', () {
    late MockUserMessagingChannel mockChannel;
    setUpAll(() async {
      mockChannel = MockUserMessagingChannel();
      UserMessagingChannel.instance = mockChannel;
    });

    test('getConsentInformation()', () async {
      ConsentInformation info = ConsentInformationImpl(1);
      when(mockChannel.getConsentInformation())
          .thenAnswer((realInvocation) => Future.value(info));

      ConsentInformation result =
          await UserMessagingPlatform.getConsentInformation();

      expect(result, info);
      verify(mockChannel.getConsentInformation());
    });
  });
}
