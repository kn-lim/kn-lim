function vscode() {
  if [ -n "$1" ]; then
    WORKSPACE_PATH="$CODE_WORKSPACES_DIR/$1.code-workspace"
    if [ -f "$WORKSPACE_PATH" ]; then
      code "$WORKSPACE_PATH"
      return 0
    else
      echo "Workspace file \"$WORKSPACE_PATH\" does not exist"
      return 1
    fi
  else
    echo "Usage: vscode <WORKSPACE_NAME>"
    return 1
  fi
}
