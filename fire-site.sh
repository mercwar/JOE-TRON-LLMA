#!/bin/bash
# IDENTITY: VERSION 4.1 // FIRE-SITE // ROBO-ROOK fire-site.sh
# ROLE: Dynamic Sitemap Generation for Root Folder Files Only (Ignores Submodules).

# 1. Get the base GitHub URL from your git config
REPO_URL=$(git config --get remote.origin.url | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//')
BRANCH="main"
BASE_URL="${REPO_URL}/blob/${BRANCH}"

OUTPUT_FILE="sitemap.xml"

echo "Generating root-level sitemap for: ${BASE_URL}"

# 2. Start the XML structure
echo '<?xml version="1.0" encoding="UTF-8"?>' > $OUTPUT_FILE
echo '<urlset xmlns="http://sitemaps.org">' >> $OUTPUT_FILE

# 3. Find regular files in the root folder only (-maxdepth 1 -type f)
find . -maxdepth 1 -type f | while read -r file; do
    # Remove the leading './'
    CLEAN_PATH="${file#./}"
    
    # Skip sitemap.xml and hidden files (like .gitmodules or .gitignore)
    if [ "$CLEAN_PATH" = "$OUTPUT_FILE" ] || [[ "$CLEAN_PATH" == .* ]]; then
        continue
    fi
    
    # URL encode spaces
    ENCODED_PATH=$(echo "$CLEAN_PATH" | sed 's/ /%20/g')
    
    # Write the URL entry
    echo "  <url>" >> $OUTPUT_FILE
    echo "    <loc>${BASE_URL}/${ENCODED_PATH}</loc>" >> $OUTPUT_FILE
    echo "  </url>" >> $OUTPUT_FILE
done

# 4. Close the tag
echo '</urlset>' >> $OUTPUT_FILE

echo "Done! Root sitemap saved to $OUTPUT_FILE"
