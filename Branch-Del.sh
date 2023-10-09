#!/usr/bin/bash

REPO_OWNER="vamsi8978"
REPO_NAME="web-app"

GITHUB_TOKEN="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"

DAYS_THRESHOLD=30

CURRENT_DATE=$(date +%s)

BRANCHES=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/branches" | grep -o '"name": "[^"]*' | sed 's/"name": "//')

for BRANCH in $BRANCHES; do
    LAST_COMMIT_DATE=$(git log -1 --format=%ct origin/$BRANCH 2>/dev/null)

    if [ -n "$LAST_COMMIT_DATE" ]; then
        DAYS_SINCE_LAST_COMMIT=$((($CURRENT_DATE - $LAST_COMMIT_DATE) / 86400))

        if [ $DAYS_SINCE_LAST_COMMIT -gt $DAYS_THRESHOLD ]; then
            echo "Deleting branch: $BRANCH"
            curl -X DELETE -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/git/refs/heads/$BRANCH"
        fi
    fi
done

echo "Branches older than $DAYS_THRESHOLD days deleted successfully."

