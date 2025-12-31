#!/bin/bash

set -e

# Init
ScriptDir=$(dirname $0)
source "$ScriptDir/base.bash"

# Tasks
setupEnvironment() {
	git config core.hooksPath "$hooksPath"
	chmod 775 "$hooksPath"/*
	mkdir -p "$buildPath"
}

# Main
main() {
	setupEnvironment
}

main
