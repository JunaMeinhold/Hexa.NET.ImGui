#!/bin/bash
# real-test-trim.sh
# Run the trim logic directly on the native folder, no dummy data

set -e

cd "$(dirname "$0")/native"

shopt -s nullglob dotglob
for artifact_dir in */; do
  if [ -d "$artifact_dir" ]; then
    artifact_name="${artifact_dir%/}"
    rtid="${artifact_name#*-}"
    if [ "$artifact_name" != "$rtid" ]; then
      for file in "$artifact_dir"/* "$artifact_dir"/.??*; do
        [ -e "$file" ] || continue
        [ -f "$file" ] && mv -n "$file" "$rtid/"
      done
      if [ -z "$(ls -A "$artifact_dir")" ]; then
        rmdir "$artifact_dir"
      fi
    fi
  fi
done

echo "\nAfter renaming, native contains:"
ls -1
