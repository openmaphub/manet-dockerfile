#!/bin/sh
docker stop manet
docker rm manet
docker build --tag="manet" .
docker run --name manet -p 8891:8891 --add-host=dev.localhost:192.168.59.1 -d manet
