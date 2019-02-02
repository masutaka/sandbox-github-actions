#!/bin/sh -eux

env | sort
jq < "$GITHUB_EVENT_PATH"

ACTION=$(jq -r '.action' < "$GITHUB_EVENT_PATH")

if [ "$ACTION" != opened ]; then
  echo "This action was ignored. (ACTION: $ACTION, ISSUE_ID: $ISSUE_ID)"
  exit 0
fi

find_project_id() {
  _PROJECT_NUMBER=$1
  _PROJECTS=$(curl -s -X GET -u "$GITHUB_ACTOR:$GITHUB_TOKEN" \
		   -H 'Accept: application/vnd.github.inertia-preview+json' \
		   "https://api.github.com/repos/$GITHUB_REPOSITORY/projects")
  _PROJECT_URL="https://github.com/$GITHUB_REPOSITORY/projects/$_PROJECT_NUMBER"
  echo "$_PROJECTS" | jq -r ".[] | select(.html_url == \"$_PROJECT_URL\").id"
  unset _PROJECT_NUMBER _PROJECTS _PROJECT_URL
}

find_column_id() {
  _PROJECT_ID=$1
  _INITIAL_COLUMN_NAME=$2
  _COLUMNS=$(curl -s -X GET -u "$GITHUB_ACTOR:$GITHUB_TOKEN" \
		  -H 'Accept: application/vnd.github.inertia-preview+json' \
		  "https://api.github.com/projects/$_PROJECT_ID/columns")
  echo "$_COLUMNS" | jq -r ".[] | select(.name == \"$_INITIAL_COLUMN_NAME\").id"
  unset _PROJECT_ID _INITIAL_COLUMN_NAME _COLUMNS
}

PROJECT_ID=$(find_project_id "$PROJECT_NUMBER")
INITIAL_COLUMN_ID=$(find_column_id "$PROJECT_ID" "$INITIAL_COLUMN_NAME")
ISSUE_ID=$(jq -r '.issue.id' < "$GITHUB_EVENT_PATH")

curl -s -X POST -u "$GITHUB_ACTOR:$GITHUB_TOKEN" \
     -H 'Accept: application/vnd.github.inertia-preview+json' \
     -d "{\"content_type\": \"Issue\", \"content_id\": $ISSUE_ID}" \
     "https://api.github.com/projects/columns/$INITIAL_COLUMN_ID/cards"
