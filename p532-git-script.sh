#!/bin/bash

# GitReplay with Bash
# P532 - Sub-project

# Made By: Ankit Sadana, Mrunal Lele, Pranav Pande, Rohith Nedunuri, Sairam Rakshith Bhyravabhotla
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

repoName=$1

repoReplayGit=git@github.com:asadana/GitReplay-playground.git

tempFolder=temp
replayFolder="replay-repo"

resetGit () {
	mkdir $tempFolder && cd $tempFolder
	git init
	echo "Something to write" >> .temp
	git add .temp
	git commit -am "Initial commit"
	git remote add origin $repoReplayGit
	git push --force --set-upstream origin master
	cd .. && rm -rf $tempFolder
}

printEcho () {
echo
echo =================================
echo
}

# Cloning the source-repo temporarily
cloneGit () {
	printEcho
	git clone $repoReplayGit $replayFolder && cd $replayFolder
	printEcho
	pwd
	printEcho
	git remote add src $repoName
	git fetch src
	printEcho

	for value in $(git rev-list --reverse src/master); do
		git cherry-pick $value
		git push origin master
	done

	echo All done
	echo Deleting temporay folder
	cd ./../ && rm -rf $replayFolder
}

resetGit
cloneGit


