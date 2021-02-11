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

if ! [ -x "$(command -v firebase)" ]; then
  echo "❌ Firebase tools CLI is missing."
  exit 1
fi

IS_CI="${CI}${CONTINUOUS_INTEGRATION}${BUILD_NUMBER}${RUN_ID}"
if [[ -n "${IS_CI}" ]]; then
  firebase emulators:start --only firestore &
  until curl --output /dev/null --silent --fail http://localhost:8080; do
    echo "Waiting for Firestore emulator to come online..."
    sleep 2
  done
  echo "Firestore emulator is online!"
else
  firebase emulators:start --only firestore
fi
