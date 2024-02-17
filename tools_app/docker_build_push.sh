set -e  # Exit immediately if a command exits with a non-zero status.

push=${1:-False}
echo "Push: $push"

cd api
BRANCH=$(git rev-parse --abbrev-ref HEAD)
IMAGENAME=dotnet-api
VERSION=$(git log -1 --format="%h-%B" | sed 's/ /-/g')
if [ $BRANCH = "main" && "$GITHUB_ACTIONS" = "true" ]; then
    VERSION=latest
fi
IMAGE=$ORGANISATION/$IMAGENAME:$VERSION
echo "Building $IMAGE"
docker build -t $IMAGE .

if [ $push = True ]; then
    docker login --username $DOCKER_USERNAME --password-stdin $DOCKER_PASSWORD
    echo "Pushing $IMAGE"
    docker push $IMAGE
fi
