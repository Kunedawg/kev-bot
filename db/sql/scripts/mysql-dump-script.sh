#!/bin/bash

# Function to check and report missing variables
check_missing_variables() {
  local variables_to_check=("$@")
  local missing_variables=()
  for var_name in "${variables_to_check[@]}"; do
    if [ -z "${!var_name}" ]; then
      missing_variables+=("$var_name")
    fi
  done
  echo "${missing_variables[@]}"
}

# Specify the list of expected environment variables
declare -a expected_env_variables=("SQL_DB_HOST" "SQL_DB_USER" "SQL_DB_PASSWORD" "SQL_DATABASE" "ENV")

# Check for missing variables
missing_variables=$(check_missing_variables "${expected_env_variables[@]}")

# Check if there is a .env file when missing variables are not empty
if [ -n "$missing_variables" ]; then
  # Check if the environment file is provided as an argument
  if [ "$#" -lt 4 ]; then
    echo "There are missing env variables: ${missing_variables}"
    echo "Usage: $0 <data_dump.sql> <schema_dump.sql> <full_dump.sql> [path/to/env_file]"
    exit 1
  fi
  env_file="$4"

  # Load missing environment variables from .env file
  if [ -f "$env_file" ]; then
    set -a
    source "$env_file"
    set -e
  else
    echo "Provided .env file does not exist: $env_file"
    exit 1
  fi
fi

# Recheck for missing variables after sourcing .env file
missing_variables=$(check_missing_variables "${expected_env_variables[@]}")
if [ -n "$missing_variables" ]; then
  echo "Env vars still missing!!"
  echo "missing vars: ${missing_variables}"
  exit 1
fi

# File names for the dumps
DATA_FILE="$1"
SCHEMA_FILE="$2"
FULL_DUMP_FILE="$3"

# Echo info
echo "Dumping..."
echo "HOST: $SQL_DB_HOST"
echo "DATABASE: $SQL_DATABASE"

# Data Dump
mysqldump -h "$SQL_DB_HOST" -u "$SQL_DB_USER" -p"$SQL_DB_PASSWORD" \
  --no-create-info --extended-insert "$SQL_DATABASE" >"$DATA_FILE"
echo "Data dump completed: $DATA_FILE"

# Schema Dump
mysqldump -h "$SQL_DB_HOST" -u "$SQL_DB_USER" -p"$SQL_DB_PASSWORD" \
  --no-data --routines --skip-triggers "$SQL_DATABASE" >"$SCHEMA_FILE"
echo "Schema dump completed: $SCHEMA_FILE"

# Complete Dump
mysqldump -h "$SQL_DB_HOST" -u "$SQL_DB_USER" -p"$SQL_DB_PASSWORD" \
  --routines --triggers "$SQL_DATABASE" >"$FULL_DUMP_FILE"
echo "Complete dump completed: $FULL_DUMP_FILE"

echo "Dump completed!"
