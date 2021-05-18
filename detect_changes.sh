#!/bin/bash -e

detect_changed_services() {

 global=(common)
 echo "----------------------------------------------"
 echo "Checking changed files for this commit"

 # get a list of all the changed folders only
 changed_folders=`git diff --name-only HEAD^ HEAD | grep / | awk 'BEGIN {FS="/"} {print $1}' | uniq`
 echo "Changed directories: "$changed_folders

 changed_services=()
 for folder in $changed_folders
 do
   if [[ " ${global[@]} " =~ " $folder " ]]; then
     echo "Changes detected in a global directory --> Building all components"
     changed_services=`find . -maxdepth 1 -type d -name '*domain' -not -path '.' | sed 's|./||'`
     echo "List of microservices: "$changed_services
     break
   else
     echo "Adding $folder to list of services to build"
     changed_services+=("$folder")
   fi
 done
}

detect_changed_services