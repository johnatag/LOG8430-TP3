#!/bin/bash

other_script_pid=$1
output_file="docker_stats.csv"

# Write the headers to the output file
echo "Container, CPU %, Memory Usage" > "$output_file"

while true; do
  # Check if the other script is still running
  if ! ps -p "$other_script_pid" > /dev/null; then
    break
  fi

  # Get the stats in CSV format
  stats=$(docker stats --no-stream --format "{{.Container}},{{.CPUPerc}},{{.MemUsage}}")

  # Append the stats to the output file
  echo "$stats" | tail -n +2 >> "$output_file"

  # Wait for 30 seconds
  sleep 30
done
