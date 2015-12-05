#!/bin/bash

# GitReplay with Bash
# P532 - Sub-project

# Made By: Ankit Sadana
# Username: asadana
# Made On: 11/24/2015

# Last Edited By: Ankit Sadana
# Username: asadana
# Last Edited On: 12/05/2015

# Source : https://github.com/asadana/GitReplay-bash-script

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
# Default value : 30s (30 seconds)
# Syntax to edit (lookup 'sleep'): [Numerical][s,m,h,d] (s-seconds, m-minutes, h-hours, d-days)
delay=30s

# Function to reintialize and empty out the repoReplayGit
resetGit () {

	printEcho
	echo "Resetting the existing replay repository"
	printEcho

	# Initializing a new git and forcing it on the repoReplayGit repository
	local tempFolder=temp
	mkdir $tempFolder && cd $tempFolder
	git init
	echo "Something to write" >> .temp
	git add .temp
	git commit -am "Initial commit"
	git remote add origin $repoReplayGit
	git push --force --set-upstream origin master
	sleep $delay
	echo
	echo "The repository for replay has been reintialized"
	cd .. && rm -rf $tempFolder
}

# Functionn to print a divider to seperate different operations 
# This is just for visual aid
printEcho () {
	echo
	echo =================================
	echo
}

# Function to get SHAs from repoName and print a ReplayMenu for the user
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
		commitsArray+=("$value")
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

		# Menu options are handled by case
		case $readOption in

			1) 	# Case for Replay Next Commit
				
				printEcho
				echo "Replaying next commit"
				printEcho
				git cherry-pick ${commitsArray[${#commitsArray[@]} - $commitArrayLength]}
				git push origin master
				((commitArrayLength--))
				sleep $delay
				echo
				echo "Remaining commits: $commitArrayLength"
				;;
			
			2)	# Case for Replaying n number of commits
 				
 				read -p "Enter the number of commits you want to replay forward: " count
 				# Checking to ensure number entered is not bigger than number of commits left
				if [ ! $count -gt $commitArrayLength ]
				then
					# Looping to the commit next n commits
					for (( i = $count; i > 0; i-- )); do
						printEcho
						git cherry-pick ${commitsArray[${#commitsArray[@]} - $commitArrayLength]}
						git push origin master
						((commitArrayLength--))
						sleep $delay
						echo
						echo "Remaining commits: $commitArrayLength"
					done
				else
					echo
					echo "The number of replay commits cannot be greater than remaining commits."
					echo "Remaining commits : $commitArrayLength"
				fi
				;;
			
			3) 	# Case for replaying all remaining commits

				printEcho
				echo "Replaying all remaining commits"

				# Loop checks the length of commitArrayLength and uses all remaining commits
				for (( i = $commitArrayLength; i > 0; i-- )); do
						printEcho
						git cherry-pick ${commitsArray[${#commitsArray[@]} - i]}
						git push origin master
						((commitArrayLength--))
						sleep $delay
						echo
						echo "Remaining commits: $commitArrayLength"
					done	
				;;
			
			4) 	# Case for exiting ReplayMenu
				echo
				echo "Exiting..."
				break
				;;
			
			*)	# Default case 
				echo
				echo "Invalid choice. Please try again"
		esac

	done

	printEcho
	# Clean up. Removing local temporary folder
	echo Deleting temporay folder
	cd ./../ && rm -rf $replayFolder
}

# Function to welcome the user to the script
welcome () {

	printEcho
	echo "Welcome to GitReplay Bash Script"
	sleep 1
}

# Welcome
welcome

# Function calls
resetGit
replayMenu


