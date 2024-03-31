# set -e  # Exit immediately if a command exits with a non-zero status.

echo "Starting script: $0..."

set -a
. ./domain.env
set +a

URL=${1:-http://localhost:$PORT/health}
echo "Url to be smoke tested is $URL..."

retries=5
wait=1
timeout=$(($wait*5))

echo "Test configured with time between retries of $wait second with a maximum of $retries retries resulting in a timeout of $timeout seconds."

counter=1
while [ $counter -le $retries ]; do
    echo "Attempt $counter..."
    echo "Requesting response..."
    response=$(curl -s -o /dev/null -w "%{http_code}" $URL)
    if [ "$response" -eq 200 ]; then
        echo "Success: HTTP status code is 200"
        exit 0
    elif [ "$response" -eq 000 ]; then
        echo "Pending: HTTP status code is 000"
    else
        echo "Error: HTTP status code is $response"
        exit 1
    fi

    sleep $wait
    echo "Waiting $wait second to ensure container is up before trying again..."
    counter=$(expr $counter + 1)
    done
echo "Timed out after $retries retries over a period of $timeout seconds."
exit 1





