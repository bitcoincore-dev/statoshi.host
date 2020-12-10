#!/usr/bin/env bash
git remote set-branches origin '*' && git fetch -v
# fetch all remote repository branch data → local repository
git branch -r | grep -v '\->' | while read remote; do git branch "${remote#origin/}" "$remote"; done
#git fetch --all
#git pull --all
