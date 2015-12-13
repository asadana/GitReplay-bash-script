GitReplay with Bash
===================
P532 - Sub-Project : Bash Script to display a menu with different options to replay commits.
----------

The script is written using Git and Bash, and can be used to grab the commits from one repository (say Repo1) and replay it in another one (say Repo2). The script resets the target repository, Repo2, by initializing a new local repository and forcing it on Repo2 upstream. The commits can be replayed incrementally using a Replay Menu.

This script is not directory specific. When executed, the script will make temporary directories in the current folder and remove them when it's finished.

Important variables 
-------------

*repoReplayGit* : Should contain Git SSH of empty/useless repository which you have push access to.
>*Note*: This repository will be reintialized and all commits from this repo will be erased before replay.

*delay* : This is the time delay between two commit/push (in seconds). By default it is set to 40 (40 seconds).
This variable just contains a numerical value, that is used to contdown between commits.

How to run
-------------

1. Navigate in Terminal to the folder where the script is located

2. Ensure that script has proper permission to execute
	```
	chmod +x p532-git-script.sh
	```

3. Ensure that git repository in the script "repoReplayGit" points to an empty/useless repository since it will be erased and reintialized before replay. Also make sure you have push access to this repository

4. Get the Git SSH (example: git@github\.com:user/repository-name.git or userName@server\.address\.edu:~/path/to/repo) for the repository you want to replay.

5. Run the script with the Git SSH from step 4 as the argument
	```
	./p532-git-script.sh git@github.com:user/repository-name.git
	or 
	./p532-git-script.sh userName@server.address.edu:~/path/to/repo
	```

6. Menu options
	> Replay Menu
	>- **Replay next commit** : Replays the next commit in the list
	>- **Replay next n commits** : Takes a numerical input from the user, say *n*. Then pushes *n* number of commits.
	>- **Replay all remaining commits** : Replays all the remaining commits from the list
	>- **Exit** : Exits the menu
