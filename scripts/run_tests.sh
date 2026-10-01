#!/bin/bash

# Copyright (c) 2026. All rights reserved.
# Use of this source code is governed by a style-guide
# that can be found in the original repository.

# ==============================================================================
# Navigate to project root if executed from scripts directory
# ==============================================================================
if [ -d "scripts" ] && [ -f "pubspec.yaml" ]; then
    # Already in root directory
    true
elif [ -d "../pubspec.yaml" ] || [ -f "../pubspec.yaml" ]; then
    # Executed from scripts directory, move up to project root
    cd ..
else
    echo "❌ Error: Could not find Flutter project root (pubspec.yaml missing)."
    exit 1
fi

# ==============================================================================
# Setup temporary storage for test analytics
# ==============================================================================

# Create a temporary file to store JSON test outputs for later parsing.
TEMP_JSON=$(mktemp)

# ==============================================================================
# Execute Flutter Tests
# ==============================================================================

# Run tests in the background using the JSON reporter to calculate metrics.
flutter test --reporter json > "$TEMP_JSON" 2>&1 &
JSON_PID=$!

# Run tests on the terminal using the 'expanded' reporter for live,
# readable output and detailed stack traces.
flutter test --reporter expanded

# Wait for the background JSON logging process to complete.
wait $JSON_PID

# ==============================================================================
# Parse Test Metrics
# ==============================================================================

# Extract total, passed, and failed test counts using jq.
TOTAL=$(jq -s '[.[] | select(.type == "testStart")] | length' "$TEMP_JSON" 2>/dev/null || echo 0)
PASSED=$(jq -s '[.[] | select(.type == "testDone" and .result == "success")] | length' "$TEMP_JSON" 2>/dev/null || echo 0)
FAILED=$(jq -s '[.[] | select(.type == "testDone" and .result != "success")] | length' "$TEMP_JSON" 2>/dev/null || echo 0)

# Clean up the temporary JSON file.
rm -f "$TEMP_JSON"

# ==============================================================================
# Display Final Summary
# ==============================================================================

# Print the final summary box if metrics were successfully extracted.
if [ "$TOTAL" -gt 0 ]; then
    echo ""
    echo "📊 =============== Final Test Summary =============== 📊"
    echo -e "🔹 Total Tests: \033[1m$TOTAL\033[0m"
    echo -e "✅ Passed:      \033[32m$PASSED\033[0m"
    echo -e "❌ Failed:      \033[31m$FAILED\033[0m"
    echo "===================================================="
fi