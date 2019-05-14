#!/bin/bash -e
echo "rnotebook rebuild"
docker image rm 127.0.0.1:5000/openstudio-rnotebook -f || true
docker build . -t="127.0.0.1:5000/openstudio-rnotebook"
docker push 127.0.0.1:5000/openstudio-rnotebook
echo 'rnotebook rebuilt and pushed to registry'

