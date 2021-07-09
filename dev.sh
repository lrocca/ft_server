echo "☞\tDeleting unused containers..."
docker container prune -f

echo "\n☞\tBuilding updated container..."
docker build . -t 42

echo "\n☞\tRunning built container..."
docker run -it -p 80:80 -p 443:443 42

echo "☞\tDeleting unused containers..."
docker container prune -f
