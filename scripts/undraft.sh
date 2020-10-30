#!/bin/sh

file=$1
now="$(date "+%Y-%m-%dT%H:%M:%S%z" | sed -e 's/00$/:00/')"

if [ -f "${file}" ]; then
    sed -i -e 's/^date: 20.*$/date: '"${now}"'/' \
           -e 's/^draft: true$/draft: false/' "${file}"
    echo "Update date: ${now}"
    echo "Update draft: false"
else
    echo "${file} not found"
    exit 1
fi
exit 0
