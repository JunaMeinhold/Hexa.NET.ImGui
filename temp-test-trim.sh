#!/bin/bash
# temp-test-trim.sh
# Simulate artifact directories and test the trim logic for rtid folders that already exist and must not be overwritten or deleted

set -e

mkdir -p Artifacts
cd Artifacts

# Simulate rtid folders with pre-existing content
for rtid in \
  android-arm64 android-x64 linux-arm64 linux-x64 osx-arm64 osx-x64 win-arm64 win-x64 win-x86

do
  mkdir -p "$rtid"
  touch "$rtid/existing-file.txt"
done

# Simulate artifact directories with files to move (including hidden file)
for name in \
  cimgui-android-arm64 \
  cimgui-android-x64 \
  cimgui-linux-arm64 \
  cimgui-linux-x64 \
  cimgui-osx-arm64 \
  cimgui-osx-x64 \
  cimgui-win-arm64 \
  cimgui-win-x64 \
  cimgui-win-x86

do
  mkdir "$name"
  touch "$name/$name.so"
  touch "$name/.hiddenfile"
done

echo "Before renaming:"
ls -1

echo "\nRunning trim logic..."
shopt -s nullglob dotglob
for artifact_dir in */; do
  if [ -d "$artifact_dir" ]; then
    artifact_name="${artifact_dir%/}"
    rtid="${artifact_name#*-}"
    if [ "$artifact_name" != "$rtid" ]; then
      mv -n "$artifact_dir"/.??* "$artifact_dir"/* "$rtid/" 2>/dev/null || true
      if [ -z "$(ls -A "$artifact_dir")" ]; then
        rmdir "$artifact_dir"
      fi
    fi
  fi
done

echo "\nAfter renaming:"
ls -1

echo "\nContents of rtid folders (should contain both existing and new files, no overwrites):"
for rtid in android-arm64 android-x64 linux-arm64 linux-x64 osx-arm64 osx-x64 win-arm64 win-x64 win-x86; do
  echo "$rtid:"
  ls -1 "$rtid"
done
