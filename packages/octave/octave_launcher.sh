#!/bin/sh
if [ -e /Applications/AquaTerm.app ]; then
    export GNUTERM=aqua
fi

exec octave-bin "$@"
