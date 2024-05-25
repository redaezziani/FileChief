#!/bin/bash

# Function to display all files in a directory
display_files() {
    dir=$1
    ls -lh "$dir"
}

# Function to search for files in a directory
search_files() {
    dir=$1
    pattern=$2
    find "$dir" -name "$pattern"
}

# Function to get files by size
get_files_by_size() {
    dir=$1
    size=$2
    find "$dir" -size "$size"
}

# Function to get files by type
get_files_by_type() {
    dir=$1
    type=$2
    find "$dir" -type "$type"
}

# Function to group files by type
group_by_type() {
    dir=$1
    for file in "$dir"/*; do
        ext=${file##*.}
        mkdir -p "$dir/$ext"
        mv "$file" "$dir/$ext/"
    done
}

# Function to group files by size
group_by_size() {
    dir=$1
    for file in "$dir"/*; do
        size=$(du -sh "$file" | cut -f1)
        mkdir -p "$dir/$size"
        mv "$file" "$dir/$size/"
    done
}

# Function to group files alphabetically
group_by_name() {
    dir=$1
    for file in "$dir"/*; do
        first_letter=$(basename "$file" | cut -c 1)
        mkdir -p "$dir/$first_letter"
        mv "$file" "$dir/$first_letter/"
    done
}

# Parse command line options
while getopts ":d:tsnaf:z:y:" option; do
    case "${option}" in
        d)
            dir=${OPTARG}
            ;;
        t)
            group_by_type "$dir"
            ;;
        s)
            group_by_size "$dir"
            ;;
        n)
            group_by_name "$dir"
            ;;
        a)
            display_files "$dir"
            ;;
        f)
            pattern=${OPTARG}
            search_files "$dir" "$pattern"
            ;;
        z)
            size=${OPTARG}
            get_files_by_size "$dir" "$size"
            ;;
        y)
            type=${OPTARG}
            get_files_by_type "$dir" "$type"
            ;;
        *)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done
