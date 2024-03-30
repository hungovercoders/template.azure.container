set -e  # Exit immediately if a command exits with a non-zero status.
APP=${1:-dotnet-api}
RUN=${2:-False}
PUSH=${3:-False}

echo "Starting script: $0..."

if [ $RUN = True ]; then
    echo "You have chosen to run the image as a container once built."
fi
if [ $RUN = False ]; then
    echo "You have chosen not to run the image as a container once built."
fi

if [ $PUSH = True ]; then
    echo "You have chosen to push the image once built, run and tested."
fi
if [ $PUSH = False ]; then
    echo "You have chosen not to push the image once built, run and tested."
fi

echo "Organisation is $ORGANISATION."
echo "App name is $APP."
CONTAINERNAME=$APP
echo "Container name is $CONTAINERNAME."
BRANCH=$(git rev-parse --abbrev-ref HEAD)
##VERSION=$(git log -1 --format="%h-%B" | sed 's/ /-/g') //this is how can use get commit versions - but I don't need this, too granular
VERSION=$ENVIRONMENT
if [ "$BRANCH" = "main" ] && [ "$GITHUB_ACTIONS" = true ]; then
    VERSION=latest
fi
echo "Version is $VERSION."
IMAGENAME=$ORGANISATION/$APP:$VERSION
echo "Image name is $IMAGENAME."

cd api
echo "Building $IMAGENAME..."
docker build -t $IMAGENAME .
echo "Built $IMAGENAME."

echo "Stopping docker container $CONTAINERNAME..."
docker stop $CONTAINERNAME
echo "Stopping docker container $CONTAINERNAME..."

if [ $RUN = True ]; then
    sh ../tools_app/docker_containers_clear.sh
    echo "Run container $CONTAINERNAME from image $IMAGENAME..."
    docker run -d -p 5240:5240 --name $CONTAINERNAME $IMAGENAME
    echo "Running container $CONTAINERNAME from image $IMAGENAME."
    sh ../test/tests.sh
fi

sh ../tools_app/docker_list.sh

if [ $PUSH = True ]; then
    echo "Logging in to Docker..."
    docker login --username $DOCKER_USERNAME --password $DOCKER_PASSWORD ##--password-stdin - how to use?
    echo "Logged in to Docker."
    echo "Pushing image $IMAGENAME..."
    docker push $IMAGENAME
    echo "Pushed image $IMAGENAME."
fi

echo "Completed script: $0."

