if [ -d ~/.e-max ]
then
  echo "\033[0;33mYou already have e-max installed.\033[0m You'll need to remove ~/.e-max if you want to reinstall"
  exit
fi

if [ -f `dirname $0`/install.sh ]; then
  if [[ `dirname $0` != /* ]]; then
    emaxdir=`dirname \`pwd\`/\`dirname $0\` | sed -e 's/\/\.$//'`  # ../
  else
    emaxdir=`dirname \`dirname $0\``
  fi

  echo "\033[0;34mYou have cloned e-max into $emaxdir, using this one...\033[0m"

else
  emaxdir=`~/.e-max`
  echo "\033[0;34mCloning e-max to $emaxdir...\033[0m"
  /usr/bin/env git clone https://github.com/senny/e-max.git $emaxdir
fi

echo "\033[0;34mLooking for an existing emacs config...\033[0m"
if [ -f ~/.emacs ] || [ -h ~/.emacs ]
then
  echo "\033[0;33mFound ~/.emacs.\033[0m \033[0;32]Backing up to ~/.emacs-pre-e-max\033[0m";
  cp ~/.emacs ~/.emacs-pre-e-max;
  rm ~/.emacs;
fi

if [ -d ~/.emacs.d ] || [ -h ~/.emacs.d ]
then
  echo "\033[0;33mFound ~/.emacs.d.\033[0m \033[0;32]Backing up to ~/.emacs.d-pre-e-max\033[0m";
  cp -r ~/.emacs.d ~/.emacs.d-pre-e-max;
  rm -r ~/.emacs.d;
fi

echo "\033[0;34mCreating a ~/.emacs.d directory, containing the emacs load file.\033[0m"
mkdir ~/.emacs.d

cat "$emaxdir/templates/init.el" | sed "s:E-MAX-DIR:$emaxdir:g" > ~/.emacs.d/init.el
# cp $emaxdir/templates/init.el ~/.emacs.d/init.el

echo "\033[0;32m"'  $$$$$$\          $$$$$$\$$$$\   $$$$$$\  $$\   $$\     '"\033[0m"
echo "\033[0;32m"'  $$  __$$\ $$$$$$\ $$  _$$  _$$\  \____$$\ \$$\ $$  |   '"\033[0m"
echo "\033[0;32m"'  $$$$$$$$ |\______|$$ / $$ / $$ | $$$$$$$ | \$$$$  /    '"\033[0m"
echo "\033[0;32m"'  $$   ____|        $$ | $$ | $$ |$$  __$$ | $$  $$<     '"\033[0m"
echo "\033[0;32m"'  \$$$$$$$\         $$ | $$ | $$ |\$$$$$$$ |$$  /\$$\    '"\033[0m"
echo "\033[0;32m"'   \_______|        \__| \__| \__| \_______|\__/  \__|   '"\033[0m"
