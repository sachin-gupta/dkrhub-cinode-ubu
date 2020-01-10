#!/bin/bash
##
## Find lines starting with first level heading in markdown and generate TOC from it
## - Sample Usage: `./scripts/add-toc.sh History.md`
##

set -Eeo pipefail # (-) is enable (+) is disable

echo "START  : Add TOC Script [File# $1]"

add_toc_to_md_file() {
    # Generate header
    echo "Table of Contents:" > genoutput.md
    echo "==================" >> genoutput.md
    echo "" >> genoutput.md

    ## Generate toc from headings, explanation follows
    ## (https://medium.com/@acrodriguez/one-liner-to-generate-a-markdown-toc-f5292112fd14)
    ##
    # - LINE1: grep -E "^#{1,N} " filters lines (or headings) starting with {1,N} numbers of #. N=1 to filter first level headings
    #   - Sample output will be lines like: `# 0.0.0 / 2020-01-10`
    # - LINE2: Use sed to generate lines (or records) of form '#:<Line Text Without Hash>:<Line Text Without Hash>'
    #   - Sample output will be lines like: `#:0.0.0 / 2020-01-10:0.0.0 / 2020-01-10`
    # - LINE3: Use awk to replace '#' with ' ' and stripping spaces and caps of reference
    #   - Sample output will be lines like: `  - [0.0.0 / 2020-01-10](#0.0.0-/-2020-01-10)`
    cat $1 | \
        grep -E "^#{1,$2} " | \
        sed -E 's/(#+) (.+)/\1:\2:\2/g' | \
        awk -F ":" '{ gsub(/#/,"  ",$1); gsub(/[ ]/,"-",$3); print $1 "- [" $2 "](#" tolower($3) ")" }' \
        >> genoutput.md

    echo "" >> genoutput.md

    # Generate footer
    echo "Detail of Contents:" >> genoutput.md
    echo "==================" >> genoutput.md
    echo "" >> genoutput.md
    cat $1 >> genoutput.md

    # Replace file (forced confirmation)
    cp -rf genoutput.md $1
}

# Generate TOC for Heading upto Level 1
add_toc_to_md_file $1 1

echo "END    : Add TOC Script [File# $1]"
