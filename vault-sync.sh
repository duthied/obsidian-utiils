#! /bin/bash

VAULT_PATH="/Users/devlon.d/obsidian-vault"

cd "$VAULT_PATH"

CHANGES_EXIST="$(git status --porcelain | wc -l)"

if [ "$CHANGES_EXIST" -eq 0 ]; then
  exit 0
fi

git pull
git add .
git commit -q -m "Last Sync $(date +"%Y-%m-%d %H:%M:%s")"
git push -q
