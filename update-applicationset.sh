#!/bin/bash

# Make the script executable
chmod +x update-applicationset.sh

# Find all directories directly under helm_charts
echo "Updating ApplicationSet.yaml with all Helm charts in helm_charts directory..."

# Create a temporary file
temp_file=$(mktemp)

# Process the ApplicationSet.yaml file
while IFS= read -r line; do
  echo "$line" >> "$temp_file"
  
  # When we find the directories section, add all helm chart directories
  if [[ "$line" == *"directories:"* ]]; then
    for chart_dir in helm_charts/*; do
      if [ -d "$chart_dir" ]; then
        echo "      - path: $chart_dir" >> "$temp_file"
      fi
    done
    
    # Skip the existing directory entries
    while IFS= read -r next_line; do
      if [[ "$next_line" != *"- path: helm_charts/"* ]]; then
        echo "$next_line" >> "$temp_file"
        break
      fi
    done
  fi
done < "ApplicationSet.yaml"

# Replace the original file
mv "$temp_file" "ApplicationSet.yaml"

echo "ApplicationSet.yaml updated successfully!"