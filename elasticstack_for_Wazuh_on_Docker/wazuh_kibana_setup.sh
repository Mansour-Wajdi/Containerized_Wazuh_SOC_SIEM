#!/bin/bash

# Load environment variables from .env file
source .env

# Variables
KIBANA_URL="http://localhost:$KIBANA_PORT"
INDEX_PATTERN_NAME="wazuh-alerts-*"
DASHBOARD_URL="https://packages.wazuh.com/integrations/elastic/4.x-8.x/dashboards/wz-es-4.x-8.x-dashboards.ndjson"
DASHBOARD_FILE="wz-es-4.x-8.x-dashboards.ndjson"

# Create index pattern
echo "Creating index pattern..."
cat <<EOF > create_index_pattern.json
{
  "attributes": {
    "title": "$INDEX_PATTERN_NAME",
    "timeFieldName": "timestamp"
  }
}
EOF

curl -X POST "$KIBANA_URL/api/saved_objects/index-pattern" -H "kbn-xsrf: true" -H "Content-Type: application/json" -d @create_index_pattern.json

# Download Wazuh dashboard file
echo "Downloading Wazuh dashboard file..."
wget -O $DASHBOARD_FILE $DASHBOARD_URL

# Import Wazuh dashboards
echo "Importing Wazuh dashboards..."
curl -X POST "$KIBANA_URL/api/saved_objects/_import" -H "kbn-xsrf: true" --form file=@$DASHBOARD_FILE

# Clean up
rm create_index_pattern.json
rm $DASHBOARD_FILE

echo "Automation completed."
