#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#$SCRIPT_DIR/password_generator.pl $*

vim \
   ./edit.sh \
   ./exe.pl \
   ../../../lib/My/Objects/Password_Generator.pm \
   ../../../lib/My/Objects/Exe.pm \
   ../../../lib/My/Utils.pm \
   ../../../lib/My/Constants.pm \

exit 0


