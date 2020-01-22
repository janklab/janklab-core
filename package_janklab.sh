#!env bash
#
# package_janklab.sh - Package Janklab as a toolbox

uname=$(uname)

case "$uname" in
  Darwin*)
    MATLAB="/Applications/MATLAB_R2019b.app/bin/matlab"
    ;;
  *)
    MATLAB="matlab"
    ;;
esac

# TODO: Probably need to do something else here to get exit status
# to reflect success of the packaging.

"$MATLAB" -batch 'load_janklab; package_toolbox'
