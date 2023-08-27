search_replace() {
    if [ $# -ne 3 ]; then
        echo "Usage: search_replace <search_pattern> <replace_pattern> <file_pattern>"
        return 1
    fi

    search_pattern="$1"
    replace_pattern="$2"
    file_pattern="$3"

    # Use find to locate files matching the specified pattern
    echo "Performing..."
    find . -type f -name "$file_pattern" -exec sed -i "s/$search_pattern/$replace_pattern/g" {} +
    echo "Done!"
}

