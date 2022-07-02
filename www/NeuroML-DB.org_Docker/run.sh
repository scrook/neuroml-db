set -e

docker-compose down --remove-orphans

./build.sh

docker-compose up