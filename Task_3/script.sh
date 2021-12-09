#!/bin/bash

# Default values
process=''
num_lines=5
state=''
field='organization'

# Get arguments
while [ $# -gt 0 ]; do
  key="$1"
  case $key in
    -h|--help)
    cat << EOF
usage: $0 process [-h|--help] [-n:5] [-s:all] [-f:organization]
  process - process name or pid
  -h, --help        Prints this help
  -n, --num_lines   Set the number of lines to be shown
  -s, --state       Choose connection state. Possible values: listen, established, time_wait, close_wait
  -f, --field       WHOIS field to fetch. Possible values: domain, status
EOF
    exit
    ;;
    -n|--num_lines)
    num_lines="${2-}"
    shift
    ;;
  -s | --state)
    state=$(echo "${2-}" | tr '[:lower:]' '[:upper:]')
    shift
    ;;
  -f | --field)
    field=$(echo "${2-}" | tr '[:upper:]' '[:lower:]')
    shift
    ;;
  -?*)
    msg "Unknown option: $1"
    exit
    ;;
  *)
    break
    ;;
  esac
  shift
done

# Process is required
if [ $# -eq 0 ]; then
  echo "Missing required argument: process name or PID";
  exit;
fi
process="${1}"

# Function itself
data="$(netstat -tunapl |
	awk '$6~/^[^0-9]/ && $5~/^[1-9]/ {
		print $5, $6, $7}' |
	column -t)"
data=$(echo "$data" | grep "$process")
data=$(echo "$data" | grep "$state")

if [ -z  "$data" ]; then
  exit;
fi

rows=$(echo "$data" | cut -d: -f1 | sort | uniq -c | sort)
rows=$(echo "$rows" | tail -n "$num_lines" | grep -oP '(\d+\.){3}\d+')

echo 'WHOIS:'
for row in $rows
do
  if [ "$field" = "organization" ]; then
    echo "$row" $'\t' "$(whois "$row" | awk -F':' '/^Organization:|^org:|^Org:/ {print $2}' | tr -s ' ' | uniq)"
  else
    echo "$row" $'\t' "$(whois "$row" | grep -i "^$field" | uniq)"
  fi
done
