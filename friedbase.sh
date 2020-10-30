#!/usr/bin/env bash

set -e

# defaults target directory to current directory if no argument is supplied
if [ "$#" -ne 1 ]
then
    dir="./"
else
    dir=${1}
fi

if [ ! -d ${dir} ]
    then
        printf "[!] Directory not found."
        exit 1
fi

printf "[i] Looking for firebaseio.com URLs... (directory: ${dir})\n\n"

# find urls with grep
urls=($(grep -iR firebaseio.com ${dir} | egrep -so "https://[a\-zA\-Z\-0\-9\-\_-]{1,}\.firebaseio\.com" | sort -u))

# if we found any firebase urls, check /.json
if [ ! -z "${urls}" ]
then
    printf "Discovered Firebase URLs:\n"
    for i in ${urls[@]}
    do
        printf " - ${i}\n"
    done

    printf "\n[i] Looking for open databases...\n\n"

    for i in ${urls[@]}
    do
        response=$(curl --silent -I -X GET ${i}/.json | cut -d ' ' -f2 | head -n1)
        if [ ${response} == 200 ]
        then
            printf "[*] Open Firebase DB: ${i}/.json\n\n"
        fi
    done
else
    printf "[!] No Firebase URLs found.\n\n"
fi
