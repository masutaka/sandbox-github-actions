FROM alpine:3.9

LABEL "com.github.actions.icon"="github"
LABEL "com.github.actions.color"="yellow"

RUN apk add --no-cache --no-progress curl=7.63.0-r0 jq=1.6-r0

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
