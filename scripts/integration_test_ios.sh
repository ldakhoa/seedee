#!/bin/bash
set -e

cd examples/ios

swift run seedee build
swift run seedee test
