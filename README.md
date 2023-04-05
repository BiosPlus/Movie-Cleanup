# Movie Cleanup

This Bash script helps you clean up your movie collection by automatically deleting lower quality copies of movies, keeping only the highest quality copy in each directory.

## Features

- Scans movie directories and identifies the best quality file based on a predefined order of preference.
- Deletes lower quality files, keeping only the highest quality copy.
- Supports dry-run mode to preview which files would be deleted without actually deleting them.
- Displays a real-time updating header with the total number of deleted and scanned files.

## Usage

1. Clone this repository or download the `cleanup_movies.sh` script.
2. Ensure the script is executable by running `chmod +x cleanup_movies.sh`.
3. Modify the `BASE_DIR` variable in the script to point to your movies base directory.
4. Run the script using one of the following options:

   - Dry-run mode (no files will be deleted, only a preview of deletions will be displayed): `./cleanup_movies.sh --dry-run` or `./cleanup_movies.sh -d`
   - Actual mode (files will be deleted): `./cleanup_movies.sh`

## Quality Preference Order

The script uses the following quality preference order:

1. Remux-1080p
2. Bluray-1080p
3. WEBDL-1080p
4. WEBRip-1080p
5. Bluray-720p
6. WEBDL-720p
7. WEBRip-720p

You can modify the `QUALITY_ORDER` array in the script to change the order of preference or add new quality options as needed.

## Important Note

Please make sure to backup your movie collection before running this script in actual mode, as it will delete files. Use the dry-run mode to preview which files will be deleted before running the script in actual mode.
