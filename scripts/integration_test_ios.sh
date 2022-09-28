#!/bin/bash
set -e

cd examples/ios

pod install

swift run seedee build --build-for-testing
swift run seedee test --test-without-building
