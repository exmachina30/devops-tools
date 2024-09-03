#!/bin/bash

for i in $(seq 1 4); do
RESPONSE=$(curl -s https://api.github.com/orgs/xxx/repos?access_token=<YOUR_GITHUB_TOKEN>&page=$i&type=all)
for row in $(echo "${RESPONSE}" | jq -r '.[].name'); do
    git clone git@github.com:xxx/$row.git
    cd $row
    for b in `git branch -r | grep -v -- '->'`; do git branch --track ${b##origin/} $b; done
    git remote add upstream https://gitlab-engineering.xxx.com/xxx/$row.git
    git push upstream --all
    cd ..
done
done