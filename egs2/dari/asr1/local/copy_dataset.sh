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

# Generate spk2utt if missing
[ ! -f data/train/spk2utt ] && utils/utt2spk_to_spk2utt.pl data/train/utt2spk > data/train/spk2utt
[ ! -f data/test/spk2utt ] && utils/utt2spk_to_spk2utt.pl data/test/utt2spk > data/test/spk2utt
[ ! -f data/valid/spk2utt ] && utils/utt2spk_to_spk2utt.pl data/valid/utt2spk > data/valid/spk2utt

echo "Dataset for $LANGUAGE/$TASK copied successfully to $DEST_DIR"
