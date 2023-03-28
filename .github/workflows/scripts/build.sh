#!/bin/bash

set -eo pipefail

ACTION=$1

# An array that holds the path to each example app
EXAMPLE_APPS_PATHS_ARRAY=()

while read -r line; do
  app_path=$(dirname "${line}");
  EXAMPLE_APPS_PATHS_ARRAY+=("${app_path#./}");
done < <(find . -name pubspec.yaml -type f -d | grep -E "${REGEX}")

install_flutter () {
  BRANCH=$1

  git clone https://github.com/flutter/flutter.git --depth 1 -b $BRANCH _flutter
  echo "$GITHUB_WORKSPACE/_flutter/bin" >> $GITHUB_PATH
}

install_tools () {
  echo "$HOME/.pub-cache/bin" >> $GITHUB_PATH
  echo "$GITHUB_WORKSPACE/_flutter/.pub-cache/bin" >> $GITHUB_PATH
  echo "$GITHUB_WORKSPACE/_flutter/bin/cache/dart-sdk/bin" >> $GITHUB_PATH
}

build_example () {
  DEFAULT_TARGET="lib/main.dart"

  ACTION=$1
  TARGET_FILE=${2:-$DEFAULT_TARGET}

  if [ "$ACTION" == "android" ]
  then
    flutter build apk --debug --target="$TARGET_FILE" --dart-define=CI=true
  fi

  if [ "$ACTION" == "ios" ]
  then
    flutter build ios --no-codesign --simulator --debug --target="$TARGET_FILE" --dart-define=CI=true
  fi
}

for example_app_path in "${EXAMPLE_APPS_PATHS_ARRAY[@]}"
do
  CHANGES="$(git --no-pager diff --name-only "${COMMIT_RANGE}")";
  echo "Project dir: ${example_app_path}";
  if [[ -n "$(grep -E "(${example_app_path}|\.github\/workflows)" <<< "${CHANGES}")" ]]; then
    echo "Building for ${example_app_path}";
    example_name=$(echo "${example_app_path}" | xargs -I{} basename {});
    echo "::set-output name=building_app::Pod install for App (${example_name})";
    pushd "${example_app_path}";
    install_flutter dev &;
    wait $!
    install_tools &;
    wait $!
    build_example "${ACTION}" ./lib/main.dart;
    popd;
  fi
done