#!/bin/bash

BASE_NAME=`basename "$0"`

if [[ "$1" = "-?" || "$1" = "-h" || "$1" = "--help" ]]
then
    cat << EOFH
Usage: bash $BASE_NAME [--help] [-R|--revert]
Apply patch.

-R, --revert    Revert previously applied embedded patch
--help          Show this help message
EOFH
    exit 0
fi

REVERT_FLAG=""
if [[ "$1" = "-R" || "$1" = "--revert" ]]
then
    REVERT_FLAG="-R"
fi

CURRENT_DIR=`pwd`/

_patch() {
    DRY_RUN_FLAG=
    if [[ "$1" = "dry-run" ]]
    then
        DRY_RUN_FLAG="--dry-run"
        echo "Checking..."
    fi
    PATCH_RESULT=`sed -e '1,/^__DIFF_FOLLOWS__$/d' "$CURRENT_DIR""$BASE_NAME" | patch $DRY_RUN_FLAG $REVERT_FLAG -p1`
    PATCH_STATUS=$?
    if [[ $PATCH_STATUS -eq 1 ]] ; then
        echo -e "ERROR:\n$PATCH_RESULT"
        exit 1
    fi
    if [[ $PATCH_STATUS -eq 2 ]] ; then
        echo "ERROR."
        exit 2
    fi
}

_patch dry-run
_patch

exit 0

__DIFF_FOLLOWS__
