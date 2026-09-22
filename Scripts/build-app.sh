#!/bin/sh
set -eu

configuration="${1:-release}"
project_root="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
app_path="$project_root/Build/Soloist.app"

swift build --configuration "$configuration" --package-path "$project_root"

mkdir -p "$app_path/Contents/MacOS"
cp "$project_root/Resources/Info.plist" "$app_path/Contents/Info.plist"
cp "$project_root/.build/$configuration/Soloist" "$app_path/Contents/MacOS/Soloist"

printf 'Created %s\n' "$app_path"
