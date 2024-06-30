#!/bin/bash
release=$(curl -sL https://api.github.com/repos/pi-hole/docker-pi-hole/releases/latest | tr -d \", | awk '/tag_name/ {print $2}')
current=$(< VERSION)
if [ $release == $current ]; then
echo "Pihole is up to date - nothing done."
else
echo "Pihole is outdated - updating."
echo  "$release" > VERSION
git commit -am "update VERSION"
git push
docker login
bash build_and_push.sh
cd ../../.. #some assumptions here
docker-compose pull && docker-compose up -d
echo "Pihole updated to $release."
fi
