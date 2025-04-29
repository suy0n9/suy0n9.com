#!/bin/sh

file=$(find content/posts -name "*.md" | fzf --prompt="Select a draft to undraft: ")

if [ -z "$file" ]; then
    echo "No file selected. Exiting."
    exit 1
fi

now="$(date "+%Y-%m-%d")"

if [ -f "${file}" ]; then
    sed -i -e 's/^date: 20.*$/date: '"${now}"'/' \
        -e 's/^draft: true$/draft: false/' "${file}"
    echo "Update file: ${file}"
    echo "Set date to: ${now}"
    echo "Draft status set to false"
else
    echo "${file} not found"
    exit 1
fi
exit 0
