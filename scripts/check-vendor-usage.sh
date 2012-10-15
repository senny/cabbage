#!/usr/bin/env bash


if [[ `dirname $0` != /* ]]; then
    # script is run with relative path (./scripts/check-vendor-usage.sh)
    if [[ $0 = './check-vendor-usage.sh' ]]; then
        # The pwd is the "scripts" repository. doing a dirname on it
        # returns the parent.
        cabbagedir=`dirname \`pwd\``
    else
        # The pwd is another relative path. We concat the pwd and the
        # script-path and remove the "check-vendor-usage.sh". Then, remove "./"
        # parts from the path..
        cabbagedir=`dirname \`pwd\`/\`dirname $0\` | sed -e 's/\/\.$//'`
    fi

else
    # script run with absolute path (/home/me/cabbage/scripts/check-vendor-usage.sh)
    cabbagedir=`dirname \`dirname $0\``
fi

echo "Cabbage directory: $cabbagedir"
echo ""
echo "This script checks how many times a vendor is used."
echo "Warning: it may say that a vendor is not used even if it is."
echo ""

for path in $cabbagedir/vendor/*; do
    name=`basename $path | sed -e 's:.el::'`
    matches=`cd $cabbagedir; git grep $name | grep -v "vendor/$name" | grep -v '^.gitmodules' | wc -l | sed -e 's/ //g'`
    if [[ "$matches" -ne "0" ]]; then
        echo -e "\033[0;32m$name\033[0m: \t\t$matches matches"
    else
        echo -e "\033[0;31m$name: \t\tNo matches with git grep. Still needed?\033[0m"
    fi
done
