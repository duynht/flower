#!/bin/sh

# Store the current branch in a variable
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Move to the top level
cd $(git rev-parse --show-toplevel)

# Clean up previous builds
rm -rf doc/build

# Create a temporary directory and store locales and _templates files in it
tmp_dir=`mktemp -d`
cp -r doc/locales ${tmp_dir}/locales
cp -r doc/source/_templates ${tmp_dir}/_templates

cd doc

# Get a list of languages based on the folders in locales
languages="en `find locales/ -mindepth 1 -maxdepth 1 -type d -exec basename '{}' \;`"
# Get a list of tags, excluding those before v1.0.0
versions="`git for-each-ref '--format=%(refname:lstrip=-1)' refs/tags/ | grep -iE '^v((([1-9]|[0-9]{2,}).*\.([5-9]|[0-9]{2,}).*)|([2-9]|[0-9]{2,}).*)$'`"

for current_version in ${versions}; do
 
  # Make the current language available to conf.py
  export current_version
  git checkout ${current_version}
  echo "INFO: Building sites for ${current_version}"
 
  changed=false
 
  for current_language in ${languages}; do

    # Make the current language available to conf.py
    export current_language
 
    echo "INFO: Building for ${current_language}"

    if [ ! -f "locales/$current_language/LC_MESSAGES/framework-docs.po" ] && [ $current_language != "en" ]; then

      # Adding translation to versions that didn't contain one
      echo "No translation, using default one"

      # Remove any previous file in locales
      rm -rf locales/$current_language
      mkdir -p locales

      # Copy updated version of locales
      cp -r ${tmp_dir}/locales/$current_language locales/
      changed=true

    fi

    # Copy updated version of html files
    cp -r ${tmp_dir}/_templates source
 
    # Actually building the docs for a given language and version
    sphinx-build -b html source/ build/html/${current_version}/${current_language} -A lang=True -D language=${current_language}

    git restore source/_templates

    # Restore branch as it was to avoid conflicts
    if [ changed ]; then
      git restore locales/${current_language} || rm -rf locales/${current_language}
    fi

  done
done
  
# Build the main version (main for GH CI, local branch for local) 
if [ $GITHUB_ACTIONS ]
then
  git switch main
else
  git switch $current_branch
fi

current_version=main
export current_version
for current_language in ${languages}; do
  export current_language
  sphinx-build -b html source/ build/html/${current_version}/${current_language} -A lang=True -D language=${current_language}
done

# Copy main version to the root of the built docs
cp -r build/html/main/en/* build/html/
