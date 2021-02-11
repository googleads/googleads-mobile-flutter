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

if ! [ -x "$(command -v node)" ]; then
  echo "❌ Node.js is missing."
  exit 1
fi

if ! [ -x "$(command -v npm)" ]; then
  echo "❌ NPM is missing."
  exit 1
fi

# Run NPM install if node modules does not exist.
if [[ ! -d "functions/node_modules" ]]; then
  cd functions && npm i && cd ..
fi

IS_CI="${CI}${CONTINUOUS_INTEGRATION}${BUILD_NUMBER}${RUN_ID}"
if [[ -n "${IS_CI}" ]]; then
  firebase emulators:start --only functions &
  until curl --output /dev/null --head --silent http://localhost:5001; do
    echo "Waiting for Functions emulator to come online..."
    sleep 2
  done
  echo "Functions emulator is online!"
else
  firebase emulators:start --only functions
fi
