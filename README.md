GitReplay with Bash
===================
P532 - Sub-Project : Bash Script to display a menu with different options to replay commits.
----------

This script is not directory specific. When executed, the script will make temporary directories in the current folder and remove them when it's finished.

Important variables 
-------------

*repoReplayGit* : Should contain Git SSH of empty/useless repository which you have push access to.
>*Note*: This repository will be reintialized and all commits from this repo will be erased before replay.

*delay* : This is the time delay between two commit/push. By default it is set to 15s (15 seconds).
Syntax to edit this value: [Numerical][s,m,h]. Here s-seconds, m-minutes and h-hours.
For further information look up 'sleep'

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
>- Replay Menu
	:	 **Replay next commit** : Replays the next commit in the list
	:	 **Replay next n commits** : Takes a numerical inut from the user, say *n*. Then pushes *n* number of commits.
	:	 **Replay all remaining commits** : Replays all the remaining commits from the list
	:	 **Exit** : Exits the menu

=======
