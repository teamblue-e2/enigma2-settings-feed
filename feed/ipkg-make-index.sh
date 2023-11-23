#!/bin/bash

set -e

D=$(pwd) &> /dev/null
R=${D}/feed

touch $R/Packages

for pkg in $(find $R -name '*.ipk' | sort); do
    echo "Generating index for package $pkg" >&2
    file_size=$(ls -l --dereference $pkg | awk '{print $5}')
    md5sum=$(md5sum $pkg | awk '{print $1}')
    pkg_name=$(basename $pkg)
    ar p $pkg control.tar.gz | tar -xzOf- './control' | sed -e "s/^Description:/Filename: $pkg_name\\
Size: $file_size\\
MD5Sum: $md5sum\\
Description:/" >> $R/Packages
    echo "" >> $R/Packages
    echo "" >> $R/Packages
done

gzip -c $R/Packages > $R/Packages.gz
