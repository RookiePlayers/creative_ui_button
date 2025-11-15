#!/usr/bin/env bash
set -euo pipefail

# Author: Olamide Ogunlade
# ...

echo "🚀 Starting version update..."

VERSION="${1-}"   # ← SAFE: expands to "" if $1 is unset
if [[ -z "$VERSION" ]]; then
  echo "❌ Error: No version string provided."
  echo "   Usage: $0 1.4.0-beta.2"
  exit 1
fi

echo "🧩 Input semantic version: $VERSION"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"

BUILD_NUMBER_FILE="$REPO_ROOT/release/build_number.txt"
PUBSPEC_FILE="$REPO_ROOT/pubspec.yaml"
PLIST_FILE="$REPO_ROOT/ios/Runner/Info.plist"

# Build number
if [[ ! -f "$BUILD_NUMBER_FILE" ]]; then
  echo "⚠️ Warning: build_number.txt not found. Creating with initial value 1."
  echo "1" > "$BUILD_NUMBER_FILE"
fi

BUILD_NUMBER="$(cat "$BUILD_NUMBER_FILE")"
echo "🔢 Current build number: $BUILD_NUMBER"
NEW_BUILD_NUMBER=$((BUILD_NUMBER + 1))
echo "$NEW_BUILD_NUMBER" > "$BUILD_NUMBER_FILE"
echo "✅ Updated build number: $NEW_BUILD_NUMBER"

# Update pubspec.yaml
if grep -q "^version: " "$PUBSPEC_FILE"; then
  echo "📦 Updating pubspec.yaml..."
  if sed --version >/dev/null 2>&1; then
    sed -i "s/^version: .*/version: $VERSION+$NEW_BUILD_NUMBER/" "$PUBSPEC_FILE"
  else
    sed -i '' "s/^version: .*/version: $VERSION+$NEW_BUILD_NUMBER/" "$PUBSPEC_FILE"
  fi
  echo "✅ pubspec.yaml updated to: $VERSION+$NEW_BUILD_NUMBER"
else
  echo "❌ pubspec.yaml does not contain a version line!"; exit 1
fi


echo "🎉 All version updates completed successfully!"