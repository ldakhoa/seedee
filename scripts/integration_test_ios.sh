#!/bin/bash
set -e

cd examples/ios
mkdir -p tmp && printf 0 > tmp/test_retries_trace # To simulate test retries

if [[ ! -d SeedeeExample.xcworkspace || ! -d Pods ]]; then
	bundle install
	bundle exec pod install
fi

common_args=(
    --derived-data-path DerivedData
)

function _exec_build() {
	swift run seedee build \
		${common_args[@]} \
		--build-for-testing
}

# function _exec_test() {}

if [[ -z ${ACTION} ]]; then
	actions=(${ACTION})
	echo "test action"
else
	actions=(${ACTION})
	echo "test action 2"
fi

for action in ${action[@]}; do
	eval "_exec_${action}"
done