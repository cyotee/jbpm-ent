#!/usr/bin/env bash

echo "Building docker.io/cyotee/jbpm-ent"
docker build -t docker.io/cyotee/jbpm-ent .
echo "Pushing docker.io/cyotee/jbpm-ent"
docker push docker.io/cyotee/jbpm-ent