#!/bin/bash
set -e

cd examples

bundle install

swift run seedee build \
    --cocoapods \
    --build-for-testing

swift run seedee test \
    --test-without-building
