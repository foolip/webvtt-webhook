#!/bin/sh -e

cd "$(dirname $0)"

setup() {
    mkdir -p jobs
    if [ ! -e webvtt ]; then
        git clone https://github.com/w3c/webvtt
    fi
}

update() {
    cd webvtt
    git fetch
    if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/master)" ]; then
        git reset --hard origin/master
        git submodule update --init -f
        ./publish.sh -f
    fi
    cd ..
}

server() {
    node webhook.js &
    trap "kill $!" EXIT
    echo "server running"
}

worker() {
    echo "worker waiting"
    inotifywait -m -q -e create --format %f jobs | while read job; do
        if [ -e "jobs/$job" ]; then
            cat jobs/*
            rm jobs/*
            echo "worker working"
            update
            echo "worker resting"
            sleep 60
            echo "worker waiting"
        fi
    done
}

setup
server
worker
