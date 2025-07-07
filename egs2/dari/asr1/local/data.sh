#!/bin/bash

# Variables
S3_URI="s3://dt-sandbox-eu-north-1-ec2-ml-trainer-ec2-ml-trainer/dari/"
DEST_DIR="data/"

# Ensure AWS CLI is installed
if ! command -v aws &> /dev/null; then
  echo "AWS CLI not found. Please install it first."
  exit 1
fi

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Sync contents recursively from S3 to local directory
aws s3 cp "$S3_URI" "$DEST_DIR" --recursive
