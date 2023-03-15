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
DEFAULT_TARGET="lib/main.dart"

ACTION=$1
TARGET_FILE=${2:-$DEFAULT_TARGET}
EXAMPLE_APP_DIRECTORY=$3

cd "$EXAMPLE_APP_DIRECTORY"

if [ "$ACTION" == "android" ]
then
  flutter build apk --debug --target="$TARGET_FILE" --dart-define=CI=true
fi

if [ "$ACTION" == "ios" ]
then
  flutter build ios --no-codesign --simulator --debug --target="$TARGET_FILE" --dart-define=CI=true
fi

