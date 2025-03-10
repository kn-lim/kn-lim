#!/bin/bash

# Directory to iterate and generate .code-workspace files
DIR_TO_ITERATE="$1"

# Directories to exclude when generating .code-workspace files (comma-separated)
EXCLUDE_DIRS="$2"

# Template for .code-workspace file
CODE_WORKSPACE_TMPL=$(cat <<EOF
{
  "folders": [
    {
      "path": "REPLACE_WITH_SUBDIR"
    }
  ],
  "settings": {}
}
EOF
)

# Function to check if a directory is in the exclude list
is_excluded() {
  local dir="$1"
  for exclude in "${EXCLUDE_DIRS_ARR[@]}"; do
    if [[ "$dir" == "$exclude" ]]; then
      return 0
    fi
  done
  return 1
}

# Check if DIR_TO_ITERATE is provided
if [ -z "$DIR_TO_ITERATE" ]; then
  echo "Usage: $0 <DIR_TO_ITERATE> [EXCLUDE_DIRS]"
  exit 1
fi

# Check if CODE_WORKSPACES_DIR exists
if [ ! -d "$CODE_WORKSPACES_DIR" ]; then
  echo "Directory $CODE_WORKSPACEs_DIR does not exist. Creating it..."
  mkdir -p "$CODE_WORKSPACES_DIR"
fi

# Convert comma-separated EXCLUDE_DIRS to array
IFS=',' read -r -a EXCLUDE_DIRS_ARR <<< "$EXCLUDE_DIRS"

COUNT=0
for subdir in "$DIR_TO_ITERATE"/*; do
  if [ -d "$subdir" ]; then
    subdir_name=$(basename "$subdir")
    if is_excluded "$subdir_name"; then
      echo "Excluding $subdir_name..."
    else
      echo "Generating .code-workspace file for $subdir_name..."
      code_workspace_file="$CODE_WORKSPACES_DIR/$subdir_name.code-workspace"
      echo "$CODE_WORKSPACE_TMPL" | sed "s|REPLACE_WITH_SUBDIR|$subdir|" > "$code_workspace_file"
      COUNT=$((COUNT+1))
    fi
  fi
done

echo "Generated $COUNT .code-workspace files in $CODE_WORKSPACES_DIR"
