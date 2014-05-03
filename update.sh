#! /bin/sh

echo "Live: $1"
echo "Updates: $2"
echo "ManifestBaseUri: $3"
echo "ManifestName: $4"

# Get the manifest file.
cd $2
rm -f $4
wget $3$4

# Check the existing version
currentVersion=$(head -n 1 $1$4)
echo "Current version: $currentVersion"

# Check the new version
newVersion=$(head -n 1 $4)
echo "Available version: $newVersion"

if [ "$newVersion" -gt "$currentVersion" ]
then
  echo "Update!"
  rm -f *.jpg *.png *~
  tail -n +2 $4 > _files.list
  wget -i _files.list
  rm -f _files.list
  cp -f * $1
fi

# Clean-up the live directory.
for file in $1*; do
  newFile=$2${file##*/}
  oldFile=$1${file##*/}

  if [ ! -f $newFile ]
  then
    rm -f $oldFile
  fi
done
