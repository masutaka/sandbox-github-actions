#!/bin/sh -ex

env | sort
jq < "$GITHUB_EVENT_PATH"

ACTION=$(jq -r '.action' < "$GITHUB_EVENT_PATH")
ISSUE_ID=$(jq -r '.issue.id' < "$GITHUB_EVENT_PATH")
ISSUE_URL=$(jq -r '.issue.url' < "$GITHUB_EVENT_PATH")

case "$ACTION" in
  opened|reopened)
    # [WIP] すでにどこかのカラムに追加された状態で reopen されたら、Move a project card を呼ぶ必要がある。
    # https://developer.github.com/v3/projects/cards/#move-a-project-card

    # Add "To do" column
    curl -s -X POST -u "$GITHUB_ACTOR:$GITHUB_TOKEN" \
	 -H 'Accept: application/vnd.github.inertia-preview+json' \
	 -d "{\"content_type\": \"Issue\", \"content_id\": $ISSUE_ID}" \
	 "https://api.github.com/projects/columns/$INITIAL_COLUMN_ID/cards"
    ;;
  closed)
    # 対象のカードを探し回る。
    ORIG_IFS=$IFS
    IFS=,
    for i in $CLOSED_TARGET_COLUMN_IDS; do
      # [WIP] Need to loop
      CARDS=$(curl -s -X GET -u "$GITHUB_ACTOR:$GITHUB_TOKEN" \
		   -H 'Accept: application/vnd.github.inertia-preview+json' \
		   "https://api.github.com/projects/columns/$i/cards")

      # Select card_id of the target issue
      CARD_ID=$(echo "$CARDS" | jq ".[] | select(.content_url == \"$ISSUE_URL\") | .id")

      if [ "$CARD_ID" ]; then
	break
      fi

      echo "$ISSUE_URL is not found in COLUMN_ID $i"
    done
    IFS=$ORIG_IFS

    if [ "$CARD_ID" ]; then
      # Move to "Done" column
      curl -s -X POST -u "$GITHUB_ACTOR:$GITHUB_TOKEN" \
	   -H 'Accept: application/vnd.github.inertia-preview+json' \
	   -d "{\"position\": \"top\", \"column_id\": $DONE_COLUMN_ID}" \
	   "https://api.github.com/projects/columns/cards/$CARD_ID/moves"
    else
      echo "Finaly, $ISSUE_URL is not found in COLUMN_IDS $CLOSED_TARGET_COLUMN_IDS"
    fi
    ;;
  *)
    echo "ACTION: $ACTION, ISSUE_ID: $ISSUE_ID, ISSUE_URL: $ISSUE_URL"
    ;;
esac
