#!/bin/bash

function command_is_installed() {

    CHECK_COMMAND=$1

    if [[ $(command -v $CHECK_COMMAND) == "" ]]; then
        return 1
    else
        return 0
    fi

}

