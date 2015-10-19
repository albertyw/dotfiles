#!/bin/bash
sshfs -o follow_symlinks -o reconnect -o cache=no REPLACEME:/home/vagrant/ ~/Desktop/REPLACEME
