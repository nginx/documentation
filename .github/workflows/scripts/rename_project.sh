#!/usr/bin/env bash
# vim:sw=2:ts=2:sts=2:et
while getopts a:n:u: flag
do
  case "${flag}" in
    a) owner=${OPTARG};;
    n) name=${OPTARG};;
    u) url=${OPTARG};;
    *) echo "Invalid flag: ${flag}"; exit 1;;
  esac
done

echo "Owner: $owner";
echo "Repository Name: $name";
echo "Repository URL: $url";

echo "Renaming repository..."

original_owner="{{REPOSITORY_OWNER}}"
original_name="{{REPOSITORY_NAME}}"
original_url="{{REPOSITORY_URL}}"
for filename in $(git ls-files)
do
  sed -i "s/$original_owner/$owner/g" "$filename"
  sed -i "s/$original_name/$name/g" "$filename"
  sed -i "s/$original_url/$url/g" "$filename"
  echo "Renamed $filename"
done

# This command runs only once on GitHub Actions!
rm -f .github/workflows/rename_template.yml
rm -rf .github/workflows/scripts
