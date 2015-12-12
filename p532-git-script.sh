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

# dealy : The time gap between two commit/push (in seconds)
# Default value : 40 (40 seconds)
delay=4

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
	sleep 2s
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

#Function to give time for Bamboo to finish building before next commit is pushed
waitTimer () {
	local timerVar=$delay
	echo
	# while loop counts down the delay and displays it
	while [[ $timerVar -ge 0 ]]; do
		echo -ne "Waiting for Bamboo to finish building: $timerVar\033[K\r"
		sleep 1s
		: $((timerVar--))
	done
}

# Function to welcome the user to the script
welcome () {

	printEcho
	echo "Welcome to GitReplay Bash Script"
	sleep 1
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
	# --first-parent is used to account for future branched use
	# --reverse ensures we get the list in oldest to newest order
	for value in $(git rev-list --first-parent --reverse src/master); do
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
		
				# If condition here is a two step process
				# We get the parent SHA from git log using the current commit SHA
				# Then using "wc -w" we count the words
				# If it's more than one word/more than one SHA, then it's a merge commit
				# And we have to specify the mainline with cherry-pick
				if [[ $(git log --pretty=%P -n 1 ${commitsArray[${#commitsArray[@]} - i]} | wc -w ) -gt 1 ]]
					then
						git cherry-pick ${commitsArray[${#commitsArray[@]} - $commitArrayLength]} --mainline 1
				else
				        git cherry-pick ${commitsArray[${#commitsArray[@]} - $commitArrayLength]}
			    fi
			    
				git push origin master
				((commitArrayLength--))
				waitTimer
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

						# If condition here is a two step process
						# We get the parent SHA from git log using the current commit SHA
						# Then using "wc -w" we count the words
						# If it's more than one word/more than one SHA, then it's a merge commit
						# And we have to specify the mainline with cherry-pick
						if [[ $(git log --pretty=%P -n 1 ${commitsArray[${#commitsArray[@]} - i]} | wc -w ) -gt 1 ]]
    						then
        						git cherry-pick ${commitsArray[${#commitsArray[@]} - $commitArrayLength]} --mainline 1
    					else
    					        git cherry-pick ${commitsArray[${#commitsArray[@]} - $commitArrayLength]}
					    fi
					    
						git push origin master
						((commitArrayLength--))
						waitTimer
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

						# If condition here is a two step process
						# We get the parent SHA from git log using the current commit SHA
						# Then using "wc -w" we count the words
						# If it's more than one word/more than one SHA, then it's a merge commit
						# And we have to specify the mainline with cherry-pick
						if [[ $(git log --pretty=%P -n 1 ${commitsArray[${#commitsArray[@]} - i]} | wc -w ) -gt 1 ]]
    						then
        						git cherry-pick ${commitsArray[${#commitsArray[@]} - i]} --mainline 1
    					else
    					        git cherry-pick ${commitsArray[${#commitsArray[@]} - i]}
					    fi

						# git cherry-pick ${commitsArray[${#commitsArray[@]} - i]}
						git push origin master
						((commitArrayLength--))
						waitTimer
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


# Welcome
welcome

# Function calls
resetGit
replayMenu


