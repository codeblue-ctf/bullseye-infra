#!/bin/sh

if [ $# -ne 0 ]; then
    for node in $@; do
        bundle exec itamae ssh -h $node -y nodes/${node}.yml --vagrant entry.rb
    done
else
    $0 web runner docker-registry
fi
