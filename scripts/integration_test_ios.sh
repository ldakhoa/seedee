#!/bin/bash
set -e

cd examples/ios

pod install

swift run seedee build \
    --cocoapods \
    --build-for-testing
    
swift run seedee test \
    --cocoapods \
    --test-without-building
