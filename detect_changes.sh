#!/bin/bash -e

detect_changed_services() {

 global=()
 echo "----------------------------------------------"
 echo "Checking changed files for this commit"

 # get a list of all the changed folders only
 changed_folders=`git diff --name-only HEAD^ HEAD | grep / | awk 'BEGIN {FS="/"} {print $1}' | uniq`
 changed_files=`git diff --name-only HEAD^ HEAD`
 echo "Changed directories: "$changed_folders
 echo "Changed files": $changed_files

changed_services=()
changed_versions=()
# check version changes
 for file in $changed_files
 do
   if [[ $file == *"VERSION"* ]]; then
     changed_versions+=("$file")
     echo `git diff $file`
   fi
 done
     

 changed_services=()
 for folder in $changed_folders
 do
   if [[ " ${global[@]} " =~ " $folder " ]]; then
     echo "Changes detected in a global directory --> Building all components"
     changed_services=`find . -maxdepth 1 -type d -name '*service*' -not -path '.' | sed 's|./||'`
     echo "List of microservices: "$changed_services
     break
   fi
 for name in $changed_versions:
 do
  changed_services+=($(echo $name | cut -d "/" -f 1))
 done
 done

 echo "${changed_versions[@]}"  

}

detect_changed_services