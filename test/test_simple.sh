set -e  # Exit immediately if a command exits with a non-zero status.

response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5240/weatherforecast)

if [ "$response" -eq 200 ]; then
    echo "Success: HTTP status code is 200"
else
    echo "Error: HTTP status code is $response"
    exit 1
fi