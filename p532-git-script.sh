#!/bin/bash

# GitReplay with Bash
# P532 - Sub-project

# Made By: Ankit Sadana, Mrunal Lele, Pranav Pande, Rohith, Sairam Rakshith
# Made On: 11/24/2015

# Last Edited By: Ankit Sadana
# Last Edited On: 11/24/2015

# Source : git@github.com:asadana/GitReplay-bash-script.git

# This script is meant to take an SSH to the source repo in git
# Example of SSH: git@github.com:user/repository-name.git

# Script takes an input of Git SSH 
# If condition simply checks if it's a valid SSH format
if [ ! ${1: -4} == ".git" ]; then
    echo "$(basename $0): Please enter a valid Git SSH." 1>&2
    exit 1
fi

