echo "image id = $1"
docker create --name doc $1 sh -c 'bundle exec middleman build --build-dir=common'
docker start doc -i
rm -fr ./mobile_sdk_documentation_published/common
docker cp doc:/srv/slate/common ./mobile_sdk_documentation_published/common
docker rm -f doc
docker image rm $1
