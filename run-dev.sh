#!/bin/sh
docker stop manet
docker rm manet
docker build --tag="manet" .
docker run --name manet -p 8891:8891 -d manet
