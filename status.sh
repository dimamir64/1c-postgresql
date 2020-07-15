#!/bin/bash

# docker ps
docker container ls
docker logs -f $(docker container ls -q)
