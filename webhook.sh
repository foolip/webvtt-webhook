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
    git fetch origin master
    if [ "$(git rev-parse HEAD)" != "$(git rev-parse FETCH_HEAD)" ]; then
        git reset --hard FETCH_HEAD
        git submodule update --init -f
        ./publish.sh -f 2>&1 | mail -s "webvtt-webhook update" root
    fi
    cd ..
}

server() {
    node webhook.js &
    trap "kill $!" EXIT
    echo "server running"
}

worker() {
    while true; do
        echo "worker waiting"
        inotifywait -e create -qq jobs
        rm jobs/*
        echo "worker working"
        update
        echo "worker resting"
        sleep 60
    done
}

setup
server
worker
