set -e  # Exit immediately if a command exits with a non-zero status.

start=${1:-True}
echo "Start: $start"

cd api
BRANCH=$(git rev-parse --abbrev-ref HEAD)
IMAGENAME=dotnet-api
##VERSION=$(git log -1 --format="%h-%B" | sed 's/ /-/g') //this is how can use get commit versions - but I don't need this, too granular
VERSION=$ENVIRONMENT
if [ $BRANCH = "main" ]; then
    VERSION=latest
fi
IMAGE=$ORGANISATION/$IMAGENAME:$VERSION

if [ $start = True ]; then
    echo "Starting docker image $IMAGE..."
    docker run -d -p 5240:5240 --name $IMAGENAME $IMAGE ## run docker image with name
fi
if [ $start = False ]; then
    echo "Stopping docker image $IMAGE..."
    docker stop $IMAGE
fi

