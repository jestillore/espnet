#!/bin/bash

# Usage: ./copy_dataset.sh <language> <task>
# Example: ./copy-dataset.sh dari asr1

set -e

LANGUAGE=$1
TASK=$2

DEST_DIR="data/"
SRC_DIR="/app/datasets/$LANGUAGE/$TASK"

# Check if the directory already exists
if [ -d "$DEST_DIR" ]; then
  echo "Directory '$DEST_DIR' already exists. Skipping this step."
  exit 0
fi

if [[ ! -d "$SRC_DIR" ]]; then
  echo "There is no dataset for the language and the task"
  exit 1
fi

mkdir -p $DEST_DIR
cp -r "$SRC_DIR"/* "$DEST_DIR/"

echo "Dataset for $LANGUAGE/$TASK copied successfully to $DEST_DIR"
