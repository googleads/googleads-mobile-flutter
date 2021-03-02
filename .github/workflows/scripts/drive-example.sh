#!/bin/bash
#  Copyright 2021 Google LLC
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  https://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

ACTION=$1

if [ "$ACTION" == "android" ]
then
  # Sleep to allow emulator to settle.
  sleep 15
  melos exec -c 1 --fail-fast --scope="$GOOGLEMOBILEADS_PLUGIN_SCOPE_EXAMPLE" --dir-exists=test_driver -- \
    flutter drive --no-pub --target=./test_driver/MELOS_PARENT_PACKAGE_NAME_e2e.dart --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "ios" ]
then
  SIMULATOR="iPhone 11"
  # Boot simulator and wait for System app to be ready.
  xcrun simctl bootstatus "$SIMULATOR" -b
  xcrun simctl logverbose "$SIMULATOR" enable
  # Sleep to allow simulator to settle.
  sleep 15
  # Uncomment following line to have simulator logs printed out for debugging purposes.
  # xcrun simctl spawn booted log stream --predicate 'eventMessage contains "flutter"' &
  melos exec -c 1 --fail-fast --scope="$GOOGLEMOBILEADS_PLUGIN_SCOPE_EXAMPLE" --dir-exists=test_driver -- \
    flutter drive -d \"$SIMULATOR\" --no-pub --target=./test_driver/MELOS_PARENT_PACKAGE_NAME_e2e.dart --dart-define=CI=true
  MELOS_EXIT_CODE=$?
  xcrun simctl shutdown "$SIMULATOR"
  exit $MELOS_EXIT_CODE
fi

if [ "$ACTION" == "macos" ]
then
  melos exec -c 1 --fail-fast --scope="$GOOGLEMOBILEADS_PLUGIN_SCOPE_EXAMPLE" --dir-exists=test_driver -- \
    flutter drive -d macos --no-pub --target=./test_driver/MELOS_PARENT_PACKAGE_NAME_e2e.dart --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "web" ]
then
  melos bootstrap
  chromedriver --port=4444 &
  melos exec -c 1 --scope="$GOOGLEMOBILEADS_PLUGIN_SCOPE_EXAMPLE" --dir-exists=web -- \
    flutter drive --no-pub --verbose-system-logs --device-id=web-server --target=./test_driver/MELOS_PARENT_PACKAGE_NAME_e2e.dart --dart-define=CI=true
  exit
fi
