#!/bin/sh
git reset *
PROJECT_DIR=.
for FILE in ${PROJECT_DIR}/*
do
    echo ${FILE}
    git add -f ${FILE}
    git commit -m 'bulk commit'
done
