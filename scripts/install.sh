#/usr/bin/env sh

if [ -f `dirname $0`/install.sh ]; then
  # already cloned manually
  if [[ `dirname $0` != /* ]]; then
    # script run with relative path (./scripts/install.sh)
    if [[ $0 = './install.sh' ]]; then
      emaxdir=`dirname \`pwd\``
    else
      emaxdir=`dirname \`pwd\`/\`dirname $0\` | sed -e 's/\/\.$//'`  # ../
    fi

  else
    # script run with absolute path (/home/me/e-max/scripts/install.sh)
    emaxdir=`dirname \`dirname $0\``
  fi

  echo -e "Using already cloned e-max repository at \033[0;32m$emaxdir\033[00m ..."

else
  emaxdir=$HOME/.e-max

  if [ -d $emaxdir ]
  then
    echo -e "\033[0;31mYou already have e-max installed.\033[0m You'll need to remove \033[0;31m$emaxdir\033[0m if you want to reinstall"
    exit 1
  fi

  echo -e "Cloning e-max to \033[0;32m$emaxdir\033[0m ..."
  /usr/bin/env git clone https://github.com/senny/e-max.git $emaxdir
  cd $emaxdir
  /usr/bin/env git submodule init
  /usr/bin/env git submodule update
fi

echo -e "Looking for an existing emacs config in your home directory..."
if [ -f ~/.emacs ] || [ -h ~/.emacs ]
then
  backupfile=`date "+~$HOME/.emacs-pre-e-max-%Y-%m-%dT%H:%M%:%S"`
  echo -e "Found \033[0;31m~/.emacs\033[0m. Backing up to \033[0;31m$backupfile\033[0m";
  mv ~/.emacs $backupfile
fi

if [ -d ~/.emacs.d ] || [ -h ~/.emacs.d ]
then
  backupdir=`date "+$HOME/.emacs.d-pre-e-max-%Y%m%d-%H%M%S"`
  echo -e "Found \033[0;31m~/.emacs.d\033[0m. Backing up to \033[0;31m$backupdir\033[0m";
  mv ~/.emacs.d $backupdir
fi

echo -e "Creating a \033[0;32m~/.emacs.d\033[0m directory, containing the emacs load file."
mkdir ~/.emacs.d

cat "$emaxdir/templates/init.el" | sed "s:E-MAX-DIR:$emaxdir:g" > ~/.emacs.d/init.el

echo ""
d="\033[0;34mX\033[0;32m"
echo -e "\033[0;32m  $d$d$d$d$d$d\          $d$d$d$d$d$d\ $d$d$d$d\   $d$d$d$d$d$d\  $d$d\   $d$d\     \033[0m"
echo -e "\033[0;32m  $d$d  __$d$d\ $d$d$d$d$d$d\ $d$d  _$d$d  _$d$d\  \____$d$d\  $d$d\ $d$d  |   \033[0m"
echo -e "\033[0;32m  $d$d$d$d$d$d$d$d |\______|$d$d / $d$d / $d$d | $d$d$d$d$d$d$d |  $d$d$d$d  /    \033[0m"
echo -e "\033[0;32m  $d$d   ____|        $d$d | $d$d | $d$d |$d$d  __$d$d | $d$d  $d$d<     \033[0m"
echo -e "\033[0;32m   $d$d$d$d$d$d$d\         $d$d | $d$d | $d$d |\ $d$d$d$d$d$d |$d$d  ^ $d$d\    \033[0m"
echo -e "\033[0;32m   \_______|        \__| \__| \__| \_______|\__/  \__|   \033[0m"
echo ""
