#!/bin/bash

if [ "$TOOLBOX_HOME" == "" ] ; then
   echo ERROR.  env var TOOLBOX_HOME is not defined
   exit 1
fi

$TOOLBOX_HOME/lang/perl/bin/apps/random_list_pick/random_list_pick.pl \
   $TOOLBOX_HOME/data/names.first.female.txt \
   $TOOLBOX_HOME/data/names.last.txt \

