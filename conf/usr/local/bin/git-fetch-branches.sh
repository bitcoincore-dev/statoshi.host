#!/usr/bin/env bash
for branch in `git branch -r|grep -v ' -> '|cut -d"/" -f2`; do git checkout $branch; git fetch; done;

