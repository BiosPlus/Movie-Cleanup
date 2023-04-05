#!/bin/bash

# Base directory
BASE_DIR="/data/piracy/mount/Movies"

# Quality preference order
QUALITY_ORDER=("Remux-1080p" "Bluray-1080p" "WEBDL-1080p" "WEBRip-1080p" "Bluray-720p" "WEBDL-720p" "WEBRip-720p")

# Initialize counters
TOTAL_DELETED=0
TOTAL_SCANNED=0

# Store cursor position
tput sc

function update_header() {
  tput rc
  tput ed
  echo "Deleted: $TOTAL_DELETED"
  echo "Scanned files: $TOTAL_SCANNED"
  echo
}

function find_matching_files() {
  local dir="$1"
  local quality="$2"
  local matching_files=()
  while IFS= read -r -d '' file; do
    matching_files+=("$file")
  done < <(find "$dir" -type f -iname "*${quality}*" -print0)
  printf '%s\n' "${matching_files[@]}"
}

function find_largest_file() {
  local largest_size=-1
  local largest_file=""
  for file in "$@"; do
    local size=$(stat -c%s "$file")
    if [ $size -gt $largest_size ]; then
      largest_size=$size
      largest_file="$file"
    fi
  done
  echo "$largest_file"
}

function find_best_quality_file() {
  local dir="$1"
  local best_file=""
  for quality in "${QUALITY_ORDER[@]}"; do
    local matching_files
    IFS=$'\n' matching_files=($(find_matching_files "$dir" "$quality"))
    if [ ${#matching_files[@]} -gt 0 ]; then
      best_file=$(find_largest_file "${matching_files[@]}")
      break
    fi
  done
  echo "$best_file"
}

function delete_files_except() {
  local dir="$1"
  local best_file="$2"
  while IFS= read -r -d '' movie_file; do
    if [ -f "$movie_file" ] && [ "$movie_file" != "$best_file" ]; then
      TOTAL_DELETED=$((TOTAL_DELETED + 1))
      if [ "$DRY_RUN" == "1" ]; then
        echo "Would delete: $(basename "$movie_file")"
      else
        echo "Deleting: $(basename "$movie_file")"
        rm "$movie_file"
      fi
    fi
    TOTAL_SCANNED=$((TOTAL_SCANNED + 1))
    update_header
  done < <(find "$dir" -type f -print0)
}

function cleanup_movies() {
  while IFS= read -r -d '' movie_dir; do
    if [ -d "$movie_dir" ]; then
      local best_file=$(find_best_quality_file "$movie_dir")
      if [ -n "$best_file" ]; then
        echo "Best quality file for $(basename "$movie_dir"): $(basename "$best_file")"
        delete_files_except "$movie_dir" "$best_file"
      fi
    fi
  done < <(find "$BASE_DIR" -mindepth 1 -maxdepth 1 -type d -print0)
}

if [ "$1" == "--dry-run" ] || [ "$1" == "-d" ]; then
  echo "
