set -e  # Exit immediately if a command exits with a non-zero status.

push=${1:-False}
echo "Push: $push"

cd api
BRANCH=$(git rev-parse --abbrev-ref HEAD)
IMAGENAME=dotnet-api
##VERSION=$(git log -1 --format="%h-%B" | sed 's/ /-/g') //this is how can use get commit versions - but I don't need this, too granular
VERSION=$ENVIRONMENT
if [ $BRANCH = "main" ]; then
    VERSION=latest
fi
IMAGE=$ORGANISATION/$IMAGENAME:$VERSION

echo "Logging in to Docker..."
docker login --username $DOCKER_USERNAME --password $DOCKER_PASSWORD ##--password-stdin - how to use?
echo "Logged in to Docker."
echo "Pushing $IMAGE..."
docker push $IMAGE
echo "Pushed $IMAGE."

