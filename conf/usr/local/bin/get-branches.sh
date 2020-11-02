#!/usr/bin/env bash
export LC_ALL=C
# fetch all remote repository branch data → local repository
git branch -r | grep -v '\->' | while read remote; do git branch "${remote#origin/}" "$remote"; done
#git fetch --all
#git pull --all
