#!/usr/bin/env bash

cloneurl="https://github.com/senny/cabbage.git"
confdir=$HOME/.emacs.d


echo ""
echo -e "\033[1;32mWelcome to the cabbage installation wizard.\033[0m"
echo ""

# git is required
/usr/bin/env git --version &> /dev/null
if [[ $? -ne 0 ]]; then
    echo -e "\033[0;31mPlease install git first. See http://git-scm.com/\033[0m"
    exit 1
fi

echo "The installation does not require any super user previliges."
echo "All file modifications will be within your user home ($HOME)."
echo ""


if [ -f `dirname $0`/install.sh ]; then
    # alread cloned, since the install.sh itself is somewhere laying around
    clone_repo=false

    if [[ `dirname $0` != /* ]]; then
        # script is run with relative path (./scripts/install.sh)
        if [[ $0 = './install.sh' ]]; then
            # The pwd is the "scripts" repository. doing a dirname on it
            # returns the parent.
            emaxdir=`dirname \`pwd\``
        else
            # The pwd is another relative path. We concat the pwd and the
            # script-path and remove the "install.sh". Then, remove "./"
            # parts from the path..
            emaxdir=`dirname \`pwd\`/\`dirname $0\` | sed -e 's/\/\.$//'`
        fi

    else
        # script run with absolute path (/home/me/cabbage/scripts/install.sh)
        emaxdir=`dirname \`dirname $0\``
    fi

    echo -e "Your cabbage repository is at \033[0;32m$emaxdir\033[0m"

else
    # If the script is run directly from curl, we are going to check out
    # the repository to ~/.cabbage.
    emaxdir=$HOME/.cabbage
    clone_repo=true

    if [ -d $emaxdir ]; then
        echo -e "\033[0;31mYou already have cabbage installed at $emaxdir\033[0m"
        echo -n "You may want to run the update script at "
        echo -e "\033[0;31m$emaxdir/scripts/update.sh\033[0m instead."
        exit 1
    else
        echo -e "cabbage will be installed to \033[0;32m$emaxdir\033[0m"
    fi

fi


echo -e "Your personal configuration files will be created at \033[0;32m$confdir\033[0m"
if [ -e $confdir ]; then
    create_backup=true
    backupdir=`date "+$HOME/.emacs.d.old-%Y%m%d-%H%M%S"`
    echo -n "Your current configuration files at $confdir will "
    echo -e "be backed up to \033[0;32m$backupdir\033[0m"
else
    create_backup=false
fi

# User confirmation
echo ""
echo -e "\033[0;32mPress enter to continue (CTRL + c to cancel)\033[0m"
(read)


# Clone the repository (usually only on through-the-web-install)
if $clone_repo; then
    echo -e "Cloning cabbage to \033[0;32m$emaxdir\033[0m ..."
    /usr/bin/env git clone $cloneurl $emaxdir || exit 1
fi

# Initialize the submodules
(cd $emaxdir && /usr/bin/env git submodule init) || exit 1
(cd $emaxdir && /usr/bin/env git submodule update) || exit 1
echo ""

# Create backup
if $create_backup; then
    echo -e "Moving \033[0;32m$confdir\033[0m to \033[0;32m$backupdir\033[0m"
    mv $confdir $backupdir
fi


# Create ~/.emacs.d
echo -e "Setting your configuration directory up (\033[0;32m$confdir\033[0m)"
templatedir=$emaxdir/templates

mkdir -p $confdir
cat "$templatedir/init.el" | sed "s:CABBAGE-DIR:$emaxdir:g" > $confdir/init.el
cp -r $templatedir/emacs.d/* $confdir

userfile="users/`whoami`.el"
mkdir -p $confdir/users
cp $templatedir/username.el $confdir/$userfile

machinefile="machines/`hostname -s`.el"
mkdir -p $confdir/machines
cp $templatedir/machine.el $confdir/$machinefile

mkdir -p $confdir/bin
ln -s $emaxdir/scripts/update.sh $confdir/bin/update-cabbage


# ASCII logo
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



# Summary / first steps

echo "The cabbage installation was successful."
echo -e  " - Your configuration is stored at \033[0;32m$confdir\033[0m"
echo -e  " - Configure your bundles at \033[0;32m$confdir/config.el\033[0m"
echo -en " - Keep your cabbage up to date with the script at"
echo -e "\033[0;32m $confdir/bin/update-cabbage \033[0m"
echo -en " - If you experience problems, feel free to create an issue at"
echo -e  "\033[0;32m https://github.com/senny/cabbage/issues \033[0m"
echo " - Your contributions to cabbage are very welcome! Send us your pull requests."
