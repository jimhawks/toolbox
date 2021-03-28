#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#$SCRIPT_DIR/password_generator.pl $*

cp exe.pl ../../password_generator.pl
cp pgen.pl ../..
cp pgen.pin.pl ../..
cp pgen.dash_group.pl ../..

exit 0


