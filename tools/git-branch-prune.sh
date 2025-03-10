# !/bin/bash

DELETED=false

# Fetch the latest changes from the remote repository
git fetch --prune

# List all local branches
for branch in $(git branch | sed 's/^\*//'); do
  # Check if the branch exists on the remote
  if ! git show-ref --verify --quiet refs/remotes/origin/${branch}; then
    # Indicate that a branch has been deleted
    DELETED=true

    # If the branch does not exist on the remote, delete it
    git branch -D ${branch}
  fi
done

if [ "$DELETED" = false ]; then
  echo "No branches deleted"
fi