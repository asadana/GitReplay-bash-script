#!/bin/bash

# GitReplay with Bash
# P532 - Sub-project

# Made By: Ankit Sadana, Mrunal Lele, Pranav Pande, Rohith Nedunuri, Sairam Rakshith Bhyravabhotla
# Made On: 11/24/2015

# Last Edited By: Ankit Sadana
# Last Edited On: 12/05/2015

# Source : git@github.com:asadana/GitReplay-bash-script.git

# ============================================================

# This script is meant to take an SSH to the source repo in git
# Example of SSH: git@github.com:user/repository-name.git
# Example of SSH for server: userName@server.address.edu:~/path/to/repo

# Script takes an input argument for the repository you want to replay when called
# Example of call: ./p532-git-script.sh git@github.com:user/repository-to-replay.git
# Example of call for server: ./p532-git-script.sh server: userName@server.address.edu:~/path/to/repo

# ============================================================

# repoName : Git SSH of the repo that needs to be replayed
repoName=$1

# repoReplayGit : Git SSH of the repo that repoName will be replayed in
# You need have push access to this repo
# NOTE: This repository will be reintialized and all commits from this repo will be erased before replay.
repoReplayGit=git@github.com:asadana/GitReplay-playground.git

# Name of the temporary folder that will be generated in the current directory
# This is deleted when the script is done
replayFolder="replay-repo"

# dealy : The time gap between two commit/push
# Default value : 15s (15 seconds)
# Syntax to edit (lookup 'sleep'): [Numerical][s,m,h,d] (s-seconds, m-minutes, h-hours, d-days)
delay=5s

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
	echo
	echo "The repository for replay has been reintialized"
	cd .. && rm -rf $tempFolder
}

# Functionn to divide each operation done, just for visual aid
printEcho () {
	echo
	echo =================================
	echo
}

# Function to get SHAs from repoName and commit them one at a time to repoReplayGit
replayMenu () {
	
	# Cloning the repoReplayGit
	printEcho
	git clone $repoReplayGit $replayFolder && cd $replayFolder
	printEcho
	# Adding the repoName as a remote and fetching it
	git remote add src $repoName
	git fetch src
	printEcho

	# Intializing the empty array
	commitsArray=("")
	# For loop gets the list of commit SHA from remote
	# Each SHA is added the commitsArray
	for value in $(git rev-list --reverse src/master); do
		echo $value
		commitsArray+=("$value")
		# sleep $delay
		# git cherry-pick $value
		# git push origin master
		# printEcho
	done

	# Storing the length of commitsArray in commitArrayLength
	commitArrayLength=${#commitsArray[@]}
	# Decreasing the length of commitArrayLength by 1 to account for empty initialization entry
	((commitArrayLength--))

	# Local variable to store input from the menu
	local readOption

	# While loop displays a ReplayMenu till commitArrayLength is 0
	# Or the user chooses the exit (#4) option
	while [ $commitArrayLength -gt 0 ] || [ $readOption -eq 4 ]; do

		# ReplayMenu options
		printEcho
		echo "1) Replay next commit"
		echo "2) Replay next n commits"
		echo "3) Replay all remaining commits"
		echo "4) Exit"
		# User input from the menu
		read -p "Please enter your choice: " readOption
		echo

		case $readOption in
			1) 
				printEcho
				echo "Replaying next commit"
				printEcho
				echo ${commitsArray[${#commitsArray[@]} - $commitArrayLength]}
				((commitArrayLength--))
				sleep $delay
				;;
			2)
 				read -p "Enter the number of commits you want to replay forward: " count
				if [ ! $count -gt $commitArrayLength ]
				then
					for (( i = $count; i > 0; i-- )); do
						printEcho
						echo ${commitsArray[${#commitsArray[@]} - $commitArrayLength]}
						((commitArrayLength--))
						sleep $delay
					done
				else
					echo
					echo "The number of replay commits cannot be greater than remaining commits."
					echo "Remaining commits : $commitArrayLength"
				fi
				;;
			3) 
				printEcho
				echo "Replaying all remaining commits"

				for (( i = $commitArrayLength; i > 0; i-- )); do
						printEcho
						echo ${commitsArray[${#commitsArray[@]} - i]}
						((commitArrayLength--))
						sleep $delay
					done	
				;;
			4) 
				echo
				echo "Exiting..."
				;;
			*)
				echo
				echo "Invalid choice. Please try again"
		esac

	done

	printEcho
	# Clean up. Removing local temporary folder
	echo All done
	echo Deleting temporay folder
	cd ./../ && rm -rf $replayFolder
}

# Function calls
resetGit
replayMenu


