#!/usr/bin/env bash

set -ex

SCRIPTS_DIR="$(cd $(dirname $0);pwd)"
DIR="$(dirname "$SCRIPTS_DIR")"
PRODUCT_NAME="CocoaToys"
BUILD_DIR="${DIR}/build"
RESOURCE_DIR="${DIR}/resources"
EXPORT_PLIST="exportOptions.plist"


cd "${DIR}"

rm -rf "${BUILD_DIR}" || true

xcodebuild -workspace "${PRODUCT_NAME}.xcworkspace" -scheme "${PRODUCT_NAME}" archive -archivePath "${BUILD_DIR}/${PRODUCT_NAME}.xcarchive"

xcodebuild -exportArchive -archivePath "${BUILD_DIR}/${PRODUCT_NAME}.xcarchive" -exportPath "${BUILD_DIR}" -exportOptionsPlist "${SCRIPTS_DIR}/${EXPORT_PLIST}"

cp "${SCRIPTS_DIR}/appdmg.json" "${RESOURCE_DIR}/PowerToys.icns" "${RESOURCE_DIR}/background.png" "${RESOURCE_DIR}/background@2.png" "${BUILD_DIR}"
npx --yes appdmg "${BUILD_DIR}/appdmg.json" "${BUILD_DIR}/${PRODUCT_NAME}.dmg"
