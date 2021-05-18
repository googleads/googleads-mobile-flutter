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

if [[ $(git ls-files --modified) ]]; then
  echo ""
  echo ""
  echo "These files are not formatted correctly:"
  for f in $(git ls-files --modified); do
    echo ""
    echo ""
    echo "-----------------------------------------------------------------"
    echo "$f"
    echo "-----------------------------------------------------------------"
    echo ""
    git --no-pager diff --unified=0 --minimal $f
    echo ""
    echo "-----------------------------------------------------------------"
    echo ""
    echo ""
  done
  if [[ $GITHUB_WORKFLOW ]]; then
    git checkout . > /dev/null 2>&1
  fi
  echo ""
  echo "❌ Some files are incorrectly formatted, see above output."
  echo ""
  echo "To fix these locally, see https://github.com/googleads/googleads-mobile-flutter/blob/master/CONTRIBUTING.md#5-contributing-code"
  exit 1
else
  echo ""
  echo "✅ All files are formatted correctly."
fi
