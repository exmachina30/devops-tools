#!/bin/bash

read -p 'Insert tag (example : v1.0.0) : ' VERSION
read -p 'Insert text description for this release : ' TEXT
read -p 'Insert username your GitHub : '  USER

BRANCH=$(git rev-parse --abbrev-ref HEAD)
REPO=${PWD##*/}
TOKEN="ee54de641518ab90566d2a7a085ce51cd187cc0f"

echo "Create release $VERSION for repo: $REPO branch: $BRANCH"
API_JSON=$(printf '{"tag_name": "%s","target_commitish": "%s","name": "%s","body": "%s","draft": false,"prerelease": false}' $VERSION $BRANCH $VERSION $TEXT)
curl --data "$API_JSON" https://api.github.com/repos/${USER}/${REPO}/releases?access_token=${TOKEN}

