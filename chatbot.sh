#!/bin/bash

# Set the necessary values
PROJECT_ID="docu-help-449706"     
AGENT_ID="6abea4e5-de71-4c6a-a0b1-b93654e63925"            
SESSION_ID="123456" 
REGION="global"                
ACCESS_TOKEN="$(gcloud auth print-access-token)"  

# API URL
API_URL="https://$REGION-dialogflow.googleapis.com/v3/projects/$PROJECT_ID/locations/$REGION/agents/$AGENT_ID/sessions/$SESSION_ID:detectIntent"

# Infinite loop to simulate continuous dialog
while true; do
    # Prompt the user for input
    echo -n "You: "
    read user_input

    # If the user enters 'exit', break the loop
    if [[ "$user_input" == "exit" ]]; then
        echo "Ending conversation..."
        break
    fi

    # Prepare the JSON payload for the API request
    request_payload=$(cat <<EOF
{
  "queryInput": {
    "text": {
      "text": "$user_input"
    },
    "languageCode": "en"
  },
  "queryParams": {
    "timeZone": "America/Los_Angeles"
  }
}
EOF
);

    # Send the request to Dialogflow using curl
    response=$(curl -s -X POST \
     -H "Authorization: Bearer $(gcloud auth print-access-token)" \
     -H "x-goog-user-project: docu-help-449706" \
     -H "Content-Type: application/json; charset=utf-8" \
     -d "$request_payload" \
     "https://global-dialogflow.googleapis.com/v3/projects/docu-help-449706/locations/global/agents/6abea4e5-de71-4c6a-a0b1-b93654e63925/sessions/1234:detectIntent")

    # Extract the response text from the API response
    response_text=$(echo "$response" | jq -r '.queryResult.responseMessages[0].text.text[0]')

    # If there's a response, display it
    if [[ "$response_text" != "null" ]]; then
        echo "Dialogflow: $response_text"
    else
        echo "Dialogflow: No valid response received."
    fi

done

