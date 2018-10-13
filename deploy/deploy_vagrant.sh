#!/bin/sh

for node in web runner docker-registry; do
    itamae ssh -h $node -y nodes/${node}.yml --vagrant entry.rb
done