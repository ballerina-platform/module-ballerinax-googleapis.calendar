#!/bin/bash

BAL_EXAMPLES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BAL_CENTRAL_DIR="$HOME/.ballerina/repositories/central.ballerina.io/"
BAL_HOME_DIR="$BAL_EXAMPLES_DIR/../ballerina"

set -e

# Read Ballerina package name
BAL_PACKAGE_NAME=$(awk -F'"' '/^name/ {print $2}' "$BAL_HOME_DIR/Ballerina.toml")

# Push the package to the local repository
cd $BAL_HOME_DIR && 
    bal pack &&
    bal push --repository=local

# Remove the cache directories in the repositories
echo 'Testing'
cacheDirs=($(ls -d "$BAL_CENTRAL_DIR"/cache-* 2>/dev/null))
for dir in "${cacheDirs[@]}"; do
    [ -d "$dir" ] && rm -r "$dir"
done
echo "Successfully cleaned the cache directories"

# Update the central repository
BAL_DESTINATION_DIR="$HOME/.ballerina/repositories/central.ballerina.io/bala/ballerinax/$BAL_PACKAGE_NAME"
BAL_SOURCE_DIR="$HOME/.ballerina/repositories/local/bala/ballerinax/$BAL_PACKAGE_NAME"
[ -d "$BAL_DESTINATION_DIR" ] && rm -r "$BAL_DESTINATION_DIR"
[ -d "$BAL_SOURCE_DIR" ] && cp -r "$BAL_SOURCE_DIR" "$BAL_DESTINATION_DIR"
echo "Successfully updated the local central repositories"

# Loop through examples in the examples directory
find $BAL_EXAMPLES_DIR -type f -name "*.bal" | while read -r file; do
    bal build --offline $file
done
