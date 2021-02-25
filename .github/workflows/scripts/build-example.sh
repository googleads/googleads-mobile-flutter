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
DEFAULT_TARGET="./test_driver/MELOS_PARENT_PACKAGE_NAME_e2e.dart"

ACTION=$1
TARGET_FILE=${2:-$DEFAULT_TARGET}

melos bootstrap

if [ "$ACTION" == "android" ]
then
  melos exec -c 1 --scope="$GOOGLEMOBILEADS_PLUGIN_SCOPE_EXAMPLE" -- \
    flutter build apk --debug --target="$TARGET_FILE" --dart-define=CI=true
  MELOS_EXIT_CODE=$?
  pkill dart || true
  pkill java || true
  pkill -f '.*GradleDaemon.*' || true
  exit $MELOS_EXIT_CODE
fi

if [ "$ACTION" == "ios" ]
then
  melos exec -c 1 --scope="$GOOGLEMOBILEADS_PLUGIN_SCOPE_EXAMPLE" -- \
    flutter build ios --no-codesign --simulator --debug --target="$TARGET_FILE" --dart-define=CI=true
  exit
fi

if [ "$ACTION" == "macos" ]
then
  melos exec -c 1 --scope="$GOOGLEMOBILEADS_PLUGIN_SCOPE_EXAMPLE" -- \
    flutter build macos --debug --target="$TARGET_FILE" --device-id=macos --dart-define=CI=true
  exit
fi
