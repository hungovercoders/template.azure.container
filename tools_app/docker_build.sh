set -e  # Exit immediately if a command exits with a non-zero status.

cd api
BRANCH=$(git rev-parse --abbrev-ref HEAD)
IMAGENAME=dotnet-api
##VERSION=$(git log -1 --format="%h-%B" | sed 's/ /-/g') //this is how can use get commit versions - but I don't need this, too granular
VERSION=$ENVIRONMENT
if [ $BRANCH = "main" ]; then
    VERSION=latest
fi
IMAGE=$ORGANISATION/$IMAGENAME:$VERSION
echo "Building $IMAGE..."
docker build -t $IMAGE .
echo "Built $IMAGE."