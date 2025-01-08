#!/bin/bash

# Get env variables and validate
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

if [ -z "$SLACK_APP_ID" ] || [ -z "$SLACK_API_TOKEN" ]; then
  echo "Error: SLACK_APP_ID and SLACK_API_TOKEN must be set in the .env file."
  exit 1
fi

# Get the Ngrok URL (assuming you're using Ngrok locally on port 4040)
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')

if [ -z "$NGROK_URL" ]; then
  echo "Error: Could not retrieve Ngrok URL."
  exit 1
fi

MANIFEST_JSON="{
    \"display_information\": {
        \"name\": \"Standup Games\",
        \"description\": \"Making things dynamic\",
        \"background_color\": \"#3056c7\"
    },
    \"features\": {
        \"bot_user\": {
            \"display_name\": \"Standup Games\",
            \"always_online\": false
        },
        \"slash_commands\": [
            {
                \"command\": \"/roll\",
                \"url\": \"${NGROK_URL}/slack/commands\",
                \"description\": \"Rolls the dice\",
                \"usage_hint\": \"Use /roll to roll a dice.\",
                \"should_escape\": false
            },
            {
                \"command\": \"/draw\",
                \"url\": \"${NGROK_URL}/slack/commands\",
                \"description\": \"Draw a card\",
                \"usage_hint\": \"Use /draw to draw a card.\",
                \"should_escape\": false
            }
        ]
    },
    \"oauth_config\": {
        \"redirect_urls\": [
            \"${NGROK_URL}\"
        ],
        \"scopes\": {
            \"bot\": [
                \"commands\"
            ]
        }
    },
    \"settings\": {
        \"org_deploy_enabled\": false,
        \"socket_mode_enabled\": false,
        \"token_rotation_enabled\": false
    }
}"

# URL-encode the manifest JSON
ENCODED_MANIFEST=$(echo "$MANIFEST_JSON" | jq -sRr @uri)

UPDATE_RESPONSE=$(curl -G "https://slack.com/api/apps.manifest.update" \
  -d "app_id=$SLACK_APP_ID" \
  -d "manifest=$ENCODED_MANIFEST" \
  -d "pretty=1" \
  -H "Authorization: Bearer $SLACK_API_TOKEN")

# Check if the update was successful by parsing JSON with jq
OK_STATUS=$(echo "$UPDATE_RESPONSE" | jq -r '.ok')

if [ "$OK_STATUS" == "true" ]; then
  echo "Manifest updated successfully with new Ngrok URL: $NGROK_URL"
else
  echo "Error updating manifest: $UPDATE_RESPONSE"
  exit 1
fi
