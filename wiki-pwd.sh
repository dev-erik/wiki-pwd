#!/bin/bash

# Default values
WORDS=4
SPECIAL_STRING=""
SPECIAL_COUNT=0

# Parsing command line arguments
while getopts w:s: option
do
    case "${option}"
    in
        w) WORDS=${OPTARG};;
        s) 
            SPECIAL_STRING=${OPTARG}
            SPECIAL_COUNT=${OPTARG}
            shift
            ;;
    esac
done

random_select() {
    echo "$1" | awk -v seed=$RANDOM 'BEGIN {srand(seed)} {a[NR]=$0} END {print a[int(rand()*NR)+1]}'
}

generate_password() {
    # Fetching the content of Wikipedia's random page with redirection handling
    CONTENT=$(curl -s -L https://en.wikipedia.org/wiki/Special:Random)

    # Extracting title using xmllint
    TITLE=$(echo "$CONTENT" | xmllint --html --xpath 'string(//h1[@id="firstHeading"])' - 2>/dev/null)

    # Extracting content and counting <p> tags using xmllint
    P_CONTENTS=$(echo "$CONTENT" | xmllint --html --xpath '//*[@id="mw-content-text"]/div/p' - 2>/dev/null)
    P_COUNT=$(echo "$P_CONTENTS" | grep -c '<p>')

    # Printing title and <p> count
    echo "Title: $TITLE"
    echo "Number of <p> tags: $P_COUNT"

    # Checking <p> tag count
    if [ "$P_COUNT" -lt 5 ]; then
        echo "Not enough <p> tags. Retrying..."
        return 1
    fi

    # Extracting words from the <p> tags
    WORDS_LIST=$(echo $P_CONTENTS | sed 's/<p>/\n/g' | sed 's/<[^>]*>//g' | tr ' ' '\n' | grep -E "^[a-zA-Z]{4,}$")

    # Generating password
    PASSWORD=""
    for i in $(seq 1 $WORDS); do
        RANDOM_WORD=$(random_select "$WORDS_LIST")
        # Capitalize the selected word
        RANDOM_WORD=$(echo "$RANDOM_WORD" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
        PASSWORD="$PASSWORD$RANDOM_WORD"
    done

    # Adding random characters from the provided string
    for i in $(seq 1 $SPECIAL_COUNT); do
        RANDOM_CHAR=$(random_select "$SPECIAL_STRING")
        PASSWORD="$PASSWORD$RANDOM_CHAR"
    done

    # Output the generated password
    echo "Generated Password: $PASSWORD"
}

# Ensure xmllint is installed
if ! command -v xmllint &> /dev/null; then
    echo "Please install xmllint to proceed."
    exit 1
fi

# Keep trying until a valid page is fetched
while ! generate_password; do
    :
done

