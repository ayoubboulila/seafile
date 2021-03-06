#!/bin/bash

SCRIPT=$(readlink -f "$0") # haiwen/seafile-server-1.3.0/upgrade/upgrade_xx_xx.sh
UPGRADE_DIR=$(dirname "$SCRIPT") # haiwen/seafile-server-1.3.0/upgrade/
INSTALLPATH=$(dirname "$UPGRADE_DIR") # haiwen/seafile-server-1.3.0/
TOPDIR=$(dirname "${INSTALLPATH}") # haiwen/

echo
echo "-------------------------------------------------------------"
echo "This script would do the minor upgrade for you."
echo "Press [ENTER] to contiune"
echo "-------------------------------------------------------------"
echo
read dummy

echo
echo "------------------------------"
echo "migrating avatars ..."
echo
media_dir=${INSTALLPATH}/seahub/media
orig_avatar_dir=${INSTALLPATH}/seahub/media/avatars
dest_avatar_dir=${TOPDIR}/seahub-data/avatars

# move "media/avatars" directory outside
if [[ ! -d ${dest_avatar_dir} ]]; then
    echo
    echo "Error: avatars directory \"${dest_avatar_dir}\" does not exist" 2>&1
    echo
    exit 1

elif [[ ! -L ${orig_avatar_dir}} ]]; then
    mv ${orig_avatar_dir}/* "${dest_avatar_dir}" 2>/dev/null 1>&2
    rm -rf "${orig_avatar_dir}"
    ln -s ../../../seahub-data/avatars ${media_dir}
fi

# update the symlink seafile-server to the new server version
seafile_server_symlink=${TOPDIR}/seafile-server-latest
if [[ -L ${seafile_server_symlink} ]]; then
    echo
    echo "updating seafile-server-latest symbolic link to ${INSTALLPATH} ..."
    echo
    if ! rm -f ${seafile_server_symlink}; then
        echo "Failed to remove ${seafile_server_symlink}"
        echo
        exit 1;
    fi

    if ! ln -s $(basename ${INSTALLPATH}) ${seafile_server_symlink}; then
        echo "Failed to update ${seafile_server_symlink} symbolic link."
        echo
        exit 1;
    fi

fi

echo "DONE"
echo "------------------------------"
echo
