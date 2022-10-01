#!/bin/bash
set -e

cd examples/ios

bundle install

swift run seedee build \
    --derived-data-path DerivedData \
    --cocoapods \
    --build-for-testing
    
swift run seedee test \
    --derived-data-path DerivedData \
    --test-without-building
