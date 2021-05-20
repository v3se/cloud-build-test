set -e
IFS='
'
echo $1
detect_changed_services() {
 cd /workspace
 global=(common) # Add shared dependency directories here
 echo "----------------------------------------------"
 echo "Checking changed files for this commit"

 # get a list of all the changed folders only
 changed_folders=`git diff --name-only $COMMIT_SHA^ $COMMIT_SHA | grep / | awk 'BEGIN {FS="/"} {print $1}' | uniq`
 changed_files=`git diff --name-only $COMMIT_SHA^ $COMMIT_SHA`
 echo "Changed directories: "$changed_folders
 echo "Changed files: "$changed_files

changed_services=()
changed_versions=()
# check version changes
 for file in $changed_files
 do
   if [[ $file == *"VERSION"* ]]; then
     changed_versions+=("$file")
     echo "----------------------------------------------"
     echo "Changed version: "
     git --no-pager diff --word-diff HEAD^ $file
   fi
 done
     

 changed_services=()
 for folder in $changed_folders
 do
   if [[ " ${global[@]} " =~ " $folder " ]]; then
     echo "Changes detected in a global directory --> Building all components"
     changed_services=`find . -type f -name 'VERSION' | sed 's|./||' | sed 's/VERSION/Dockerfile/g'`
     echo "${changed_services[@]}" > release_candidates.txt
     break
   else
     for name in $changed_versions
     do
     changed_services+=($(echo $name | sed 's/VERSION/Dockerfile/g'))
     done
    fi
 done
 
 echo "----------------------------------------------"
 echo "${changed_services[*]}" > release_candidates.txt
 echo "Building the following components: "
 echo """${changed_services[*]}" 

}

detect_changed_services