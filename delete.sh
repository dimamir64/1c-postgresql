#!/bin/bash

docker container kill 1c-postgresql 2>/dev/null
docker container rm   1c-postgresql 2>/dev/null
docker volume rm pg-12-data
