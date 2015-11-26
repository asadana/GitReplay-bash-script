GitReplay with Bash
===================
P532 - Sub-Project : Bash Script to replay commits one at a time to test builds
----------

This script is not directory specific. When executed, the script will make temporary directories in the current folder and remove them when it's finished.

Important variables 
-------------
*repoReplayGit* : Should contain Git SSH of empty/useless repository which you have push access to.
>*Note*: This repository will be reintialized and all commits from this repo will be erased before replay.

*delay* : This is the time between two commit push. By default it is set to 15s (15 seconds).
Syntax to edit this value: [Numerical][s,m,h]. Here s-seconds, m-minutes and h-hours.
For further information look up 'sleep'

How to run
-------------
Steps to run go here

1. Navigate in Terminal to the folder where the script is located
2. Ensure that script has proper permission to execute
```
chmod +x p532-git-script.sh 
```
3. Get the Git SSH (example: git@github.com:user/repository-name.git)
4. Run the script with the Git SSH
```
./p532-git-script.sh git@github.com:user/repository-name.git
```


