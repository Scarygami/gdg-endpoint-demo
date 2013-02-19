#!/bin/bash

set -e

#####
# Type Analysis

echo
echo "dart_analyzer lib/*.dart"

results=`dart_analyzer lib/*.dart 2>&1`

echo "$results"

if [ -n "$results" ]; then
    exit 1
else
    echo "Passed analysis."
fi
