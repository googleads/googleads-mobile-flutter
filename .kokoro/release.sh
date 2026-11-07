#!/bin/bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-true}"
if [[ "${DRY_RUN}" != "true" && "${DRY_RUN}" != "false" ]]; then
  echo "ERROR: DRY_RUN must be 'true' or 'false' (got '${DRY_RUN}')." >&2
  exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_DIR}"

echo "=== Building and Releasing from: ${REPO_DIR} (DRY_RUN=${DRY_RUN}) ==="

PACKAGE_NAME="google_mobile_ads"
PACKAGE_DIR="${REPO_DIR}/packages/google_mobile_ads"
PACKAGE_VERSION="$(sed -n 's/^version:[[:space:]]*\([^[:space:]]*\).*/\1/p' "${PACKAGE_DIR}/pubspec.yaml" | head -n 1)"
if [[ -z "${PACKAGE_VERSION}" ]]; then
  echo "ERROR: Could not extract version from ${PACKAGE_DIR}/pubspec.yaml" >&2
  exit 1
fi
echo "Package: ${PACKAGE_NAME}, Version: ${PACKAGE_VERSION}"

rm -rf artifacts/
mkdir -p artifacts/
tar -czf "artifacts/${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz" -C "${PACKAGE_DIR}" .

EXIT_GATE_PROJECT="oss-exit-gate-prod"
EXIT_GATE_LOCATION="us"
EXIT_GATE_REPOSITORY="googleads-flutter--pubdev"

if gcloud artifacts packages describe "${PACKAGE_NAME}" \
    --project="${EXIT_GATE_PROJECT}" \
    --location="${EXIT_GATE_LOCATION}" \
    --repository="${EXIT_GATE_REPOSITORY}" &>/dev/null; then
  echo "=== Deleting existing package '${PACKAGE_NAME}' from Exit Gate staging repository ==="
  gcloud artifacts packages delete "${PACKAGE_NAME}" \
    --project="${EXIT_GATE_PROJECT}" \
    --location="${EXIT_GATE_LOCATION}" \
    --repository="${EXIT_GATE_REPOSITORY}" \
    --quiet
fi

echo "=== Uploading package archive to Exit Gate staging repository ==="
gcloud artifacts generic upload \
  --project="${EXIT_GATE_PROJECT}" \
  --location="${EXIT_GATE_LOCATION}" \
  --repository="${EXIT_GATE_REPOSITORY}" \
  --package="${PACKAGE_NAME}" \
  --version="${PACKAGE_VERSION}" \
  --source-directory=artifacts/

if [[ "${DRY_RUN}" == "true" ]]; then
  echo "=== DRY_RUN is enabled. Skipping manifest upload to Exit Gate. ==="
  exit 0
fi

cat <<EOF > manifest.json
{
  "publish_all": false,
  "publishing_groups": [
    {
      "packages": [
        {
          "name": "${PACKAGE_NAME}",
          "version": "${PACKAGE_VERSION}"
        }
      ]
    }
  ]
}
EOF

EXIT_GATE_BUCKET="gs://oss-exit-gate-prod-projects-bucket/googleads-flutter/pubdev/manifests"
MANIFEST_NAME="manifest-$(date +%Y%m%d%H%M%S).json"

echo "=== Uploading manifest to ${EXIT_GATE_BUCKET}/${MANIFEST_NAME} ==="
gcloud storage cp manifest.json "${EXIT_GATE_BUCKET}/${MANIFEST_NAME}"
