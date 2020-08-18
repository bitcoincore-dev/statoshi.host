#!/bin/bash
# Execute on the most recent composed image
D_ID1=$(echo $(docker ps | awk '{print $1}' | awk 'NR==2'))
echo $D_ID1
echo "./docker/cli-exec.sh"
#docker exec -it $D_ID1 sh -c  "ls" \
docker exec -it $D_ID1 sh -c  "/usr/local/bin/bitcoin-cli gettxoutsetinfo"

