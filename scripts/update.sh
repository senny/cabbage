#!/usr/bin/env bash

if [[ `dirname $0` != /* ]]; then
  # script run with relative path (./scripts/install.sh)
    if [[ $0 = './update.sh' ]]; then
        cabbagedir=`dirname \`pwd\``
    else
        cabbagedir=`dirname \`pwd\`/\`dirname $0\` | sed -e 's/\/\.$//'`  # ../
    fi

else
  # script run with absolute path (/home/me/cabbage/scripts/install.sh)
    cabbagedir=`dirname \`dirname $0\``
fi

if [[ $1 == "-f" || `(cd $cabbagedir && /usr/bin/env git status -uno | tail -1)` =~ "nothing to commit" ]]; then
    echo ""
else
    echo -e "\033[1;31mERROR:\033[0;31m Cannot update: You have unstaged changes. Please commit or stash them.\033[00m"
    exit 1
fi

orig_head=`(cd $cabbagedir && cat .git/ORIG_HEAD)`

echo -e "Updating cabbage at \033[0;32m$cabbagedir\033[00m ..."

echo -e "$ \033[0;33mgit fetch --prune origin\033[00m ..."
(cd $cabbagedir && /usr/bin/env git fetch --prune origin)

echo -e "$ \033[0;33mgit pull --ff-only origin master\033[00m ..."
(cd $cabbagedir && /usr/bin/env git pull --ff-only origin master)

echo -e "$ \033[0;33mgit submodule init\033[00m ..."
(cd $cabbagedir && /usr/bin/env git submodule init)

echo -e "$ \033[0;33mgit submodule sync\033[00m ..."
(cd $cabbagedir && /usr/bin/env git submodule sync)

echo -e "$ \033[0;33mgit submodule update\033[00m ..."
(cd $cabbagedir && /usr/bin/env git submodule update)

echo ""
d="\033[0;34m$\033[0;32m"
echo -e "\033[0;32m                      $d$d\       $d$d\\033[0m"
echo -e "\033[0;32m                      $d$d |      $d$d |\033[0m"
echo -e "\033[0;32m   $d$d$d$d$d$d$d\  $d$d$d$d$d$d\  $d$d$d$d$d$d$d\  $d$d$d$d$d$d$d\   $d$d$d$d$d$d\   $d$d$d$d$d$d\   $d$d$d$d$d$d\\033[0m"
echo -e "\033[0;32m  $d$d  _____| \____$d$d\ $d$d  __$d$d\ $d$d  __$d$d\  \____$d$d\ $d$d  __$d$d\ $d$d  __$d$d\\033[0m"
echo -e "\033[0;32m  $d$d /       $d$d$d$d$d$d$d |$d$d |  $d$d |$d$d |  $d$d | $d$d$d$d$d$d$d |$d$d /  $d$d |$d$d$d$d$d$d$d$d |\033[0m"
echo -e "\033[0;32m  $d$d |      $d$d  __$d$d |$d$d |  $d$d |$d$d |  $d$d |$d$d  __$d$d |$d$d |  $d$d |$d$d   ____|\033[0m"
echo -e "\033[0;32m  \\\\$d$d$d$d$d$d$d\ \\\\$d$d$d$d$d$d$d |$d$d$d$d$d$d$d  |$d$d$d$d$d$d$d  |\\\\$d$d$d$d$d$d$d |\\\\$d$d$d$d$d$d$d |\\\\$d$d$d$d$d$d$d\\033[0m"
echo -e "\033[0;32m   \_______| \_______|\_______/ \_______/  \_______| \____$d$d | \_______|\033[0m"
echo -e "\033[0;32m                                                    $d$d\   $d$d |\033[0m"
echo -e "\033[0;32m                                                    \\\\$d$d$d$d$d$d  |\033[0m"
echo -e "\033[0;32m                                                     \______/\033[0m"
echo ""


echo ""
echo "CHANGELOG:"
echo ""
if [[ $orig_head == `(cd $cabbagedir && cat .git/ORIG_HEAD)` ]]; then
    echo "  Nothing changed."
else
    (cd $cabbagedir && git --no-pager log --format="%C(blue)%h%Creset %s [%C(red)%an%Creset, %C(cyan)%cr%Creset] %C(bold reverse)%N%Creset%n        %b%n" --first-parent `cat .git/ORIG_HEAD`..HEAD)
fi
echo ""
