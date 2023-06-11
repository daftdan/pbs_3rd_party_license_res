#!/bin/sh
# for LSTC's own license server for LS-DYNA, will be obsolete after their move to FLEXNet
/apps/ls-dyna/licensing/lstc_qrun 2> /dev/null -r | awk '/MPPDYNA /{print $4}'
