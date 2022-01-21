#!/bin/bash

test_integration () {
    output="$(docker build -t dummy_project:$1 . -q --build-arg PY_VERSION=$1 &> /dev/null)"
    if [[ $? == 0 ]]; then
        output="$(docker run dummy_project:$1 &> /dev/null)"
        if [[ $? == 0 ]]; then
            echo "Python $1 integration succeeded!"
        else
            echo "Python $1 integration failed!"
        fi
    else
        echo "Python $1 integration failed!"
    fi
} 

test_integration 3.8 
test_integration 3.9 
test_integration 3.10 
test_integration 3.7 
test_integration 2.7