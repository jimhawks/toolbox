#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


$SCRIPT_DIR/password_generator.pl -dg $*

exit 0

