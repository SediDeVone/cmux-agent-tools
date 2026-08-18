#!/bin/bash
# browser-automation.sh - Examples of cmux browser CLI automation.

set -e

echo "=== Starting cmux Browser Automation Demo ==="

# 1. Open the browser split inside active workspace
echo "Opening browser split..."
cmux browser open-split "https://github.com"

# 2. Wait for page load by waiting for a selector
echo "Waiting for main content to load..."
cmux browser wait --selector "main" --timeout-ms 5000

# 3. Focus search input and type a query
# Note: CSS selectors are used to identify target elements
echo "Searching for 'cmux' repository..."
cmux browser click "[placeholder='Search or jump to...']" || true
# Alternatively, click the search button
cmux browser click ".search-input" || true

# Wait for search overlay if applicable, then type
sleep 1
cmux browser type "input[type='text']" "manaflow-ai/cmux" || true
cmux browser press "Enter" || true

# 4. Wait for search results
echo "Waiting for search results..."
sleep 2

# 5. Capture a screenshot of the search results
echo "Capturing screenshot..."
cmux browser screenshot --out "github-search.png"

# 6. Evaluate JavaScript on the page
echo "Retrieving page title via JS evaluation..."
PAGE_TITLE=$(cmux browser eval "document.title")
echo "Page title: $PAGE_TITLE"

echo "=== Browser Automation Demo Complete! ==="
echo "Screenshot saved as github-search.png"
