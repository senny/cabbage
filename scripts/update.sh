#/usr/bin/env sh

if [[ `dirname $0` != /* ]]; then
  # script run with relative path (./scripts/install.sh)
    if [[ $0 = './update.sh' ]]; then
        emaxdir=`dirname \`pwd\``
    else
        emaxdir=`dirname \`pwd\`/\`dirname $0\` | sed -e 's/\/\.$//'`  # ../
    fi

else
  # script run with absolute path (/home/me/e-max/scripts/install.sh)
    emaxdir=`dirname \`dirname $0\``
fi

if [[ `git status -uno | tail -1` =~ "nothing to commit" ]]; then
    echo ""
else
    echo -e "\033[1;31mERROR:\033[0;31m Cannot update: You have unstaged changes. Please commit or stash them.\033[00m"
    exit 1
fi

echo -e "Updating e-max at \033[0;32m$emaxdir\033[00m ..."

echo -e "$ \033[0;33mgit pull --ff-only\033[00m ..."
/usr/bin/env git pull --ff-only

echo -e "$ \033[0;33mgit submodule init\033[00m ..."
/usr/bin/env git submodule init

echo -e "$ \033[0;33mgit submodule update\033[00m ..."
/usr/bin/env git submodule update


echo ""
d="\033[0;34mX\033[0;32m"
echo -e "\033[0;32m  $d$d$d$d$d$d\          $d$d$d$d$d$d\ $d$d$d$d\   $d$d$d$d$d$d\  $d$d\   $d$d\     \033[0m"
echo -e "\033[0;32m  $d$d  __$d$d\ $d$d$d$d$d$d\ $d$d  _$d$d  _$d$d\  \____$d$d\  $d$d\ $d$d  |   \033[0m"
echo -e "\033[0;32m  $d$d$d$d$d$d$d$d |\______|$d$d / $d$d / $d$d | $d$d$d$d$d$d$d |  $d$d$d$d  /    \033[0m"
echo -e "\033[0;32m  $d$d   ____|        $d$d | $d$d | $d$d |$d$d  __$d$d | $d$d  $d$d<     \033[0m"
echo -e "\033[0;32m   $d$d$d$d$d$d$d\         $d$d | $d$d | $d$d |\ $d$d$d$d$d$d |$d$d  ^ $d$d\    \033[0m"
echo -e "\033[0;32m   \_______|        \__| \__| \__| \_______|\__/  \__|   \033[0m"
echo ""
