#!/bin/bash

set -eo pipefail

ACTION=$1

# An array that holds the path to each example app
EXAMPLE_APPS_PATHS_ARRAY=()

while read -r line; do
  app_path=$(dirname "${line}");
  EXAMPLE_APPS_PATHS_ARRAY+=("${app_path#./}");
done < <(find . -name pubspec.yaml -type f -d | grep -E "${REGEX}")

for example_app_path in "${EXAMPLE_APPS_PATHS_ARRAY[@]}"
do
  CHANGES="$(git --no-pager diff --name-only "${COMMIT_RANGE}")";
  echo "Project dir: ${example_app_path}";
  if [[ -n "$(grep -E "(${example_app_path}|\.github\/workflows)" <<< "${CHANGES}")" ]]; then
    echo "Building for ${example_app_path}";
    example_name=$(echo "${example_app_path}" | xargs -I{} basename {});
    echo "::set-output name=building_app::Pod install for App (${example_name})";
    pushd "${example_app_path}";
    bash install-flutter.sh dev
    bash install-tools.sh
    bash build-example.sh "${ACTION}" "${example_app_path}"
    popd;
  fi
done
