#!/bin/bash

APP_ID="d5689850"

case "$1" in
  status)
    appflow build list-builds --app-id="$APP_ID" --first 1 --json | jq '.buildList[0]'
    ;;
  logs)
    if [ -n "$2" ]; then
        BUILD_ID="$2"
    else
        BUILD_ID=$(appflow build list-builds --app-id="$APP_ID" --first 1 --json | jq -r '.buildList[0].buildId')
    fi
    
    echo "Fetching logs for Build ID: $BUILD_ID"
    # Using the user's preferred command structure
    appflow build logs --app-id="$APP_ID" --build-id="$BUILD_ID" -v --json
    ;;
  build)
    COMMIT_HASH=$(git rev-parse HEAD)
    echo "Triggering new Android Debug build for commit: $COMMIT_HASH"
    appflow build android debug --app-id="$APP_ID" --commit="$COMMIT_HASH"
    ;;
  *)
    echo "Usage: $0 {status|logs [build_id]|build}"
    echo "  status: Get the info of the last build"
    echo "  logs: Get logs of the last build (or specific build_id if provided)"
    echo "  build: Trigger new android debug build with current HEAD commit"
    exit 1
    ;;
esac
