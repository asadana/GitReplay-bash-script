#!/bin/bash

# GitReplay with Bash
# P532 - Sub-project

# Made By: Ankit Sadana, Mrunal Lele, Pranav Pande, Rohith Nedunuri, Sairam Rakshith Bhyravabhotla
# Made On: 11/24/2015

# Last Edited By: Ankit Sadana
# Last Edited On: 11/26/2015

# Source : git@github.com:asadana/GitReplay-bash-script.git

# This script is meant to take an SSH to the source repo in git
# Example of SSH: git@github.com:user/repository-name.git

# Script takes an input argument for the repository you want to replay when called
# Example of call: ./p532-git-script.sh git@github.com:user/repository-to-replay.git

# If condition simply checks if it's a valid SSH format
if [ ! -d .git ]; then
    echo "$(basename $0): not a git directory." 1>&2
    exit 1
fi

# repoName : Git SSH of the repo that needs to be replayed
repoName=$1

# repoReplayGit : Git SSH of the repo that repoName will be replayed in
# You need have push access to this repo
# NOTE: This repository will be reintialized and all commits from this repo will be erased before replay.
repoReplayGit=./../repos/fall2015/project/sonartest

# Name of the temporary folder that will be generated in the current directory
# This is deleted when the script is done
replayFolder="replay-repo"

# dealy : The time gap between two commit/push
# Default value : 15s (15 seconds)
# Syntax to edit (lookup 'sleep'): [Numerical][s,m,h,d] (s-seconds, m-minutes, h-hours, d-days)
delay=1s

# Function to reintialize and empty out the repoReplayGit
resetGit () {
	# Initializing a new git and forcing it on the repoReplayGit repository
	local tempFolder=temp
	mkdir $tempFolder && cd $tempFolder
	git init
	echo "Something to write" >> .temp
	git add .temp
	git commit -am "Initial commit"
	git remote add origin $repoReplayGit
	git push --force --set-upstream origin master
	cd .. && rm -rf $tempFolder
}

# Functionn to divide each operation done, just for visual aid
printEcho () {
	echo
	echo =================================
	echo
}

# Function to get SHAs from repoName and commit them one at a time to repoReplayGit
replayGit () {
	
	# Cloning the repoReplayGit
	printEcho
	git clone $repoReplayGit $replayFolder && cd $replayFolder
	printEcho
	# Adding the repoName as a remote and fetching it
	git remote add src $repoName
	git fetch src
	printEcho

	# For loop gets the list of commit SHA from remote
	# Each SHA is then used to commit to repoReplayGit
	for value in $(git rev-list --reverse src/master); do
		sleep $delay
		git cherry-pick $value
		git push origin master
		printEcho
	done

	# Clean up. Removing local temporary folder
	echo All done
	echo Deleting temporay folder
	cd ./../ && rm -rf $replayFolder
}

# Function calls
resetGit
replayGit


