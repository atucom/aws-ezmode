#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

if grep source.*aws-functions.sh $HOME/.bash_profile > /dev/null; then
    echo Already installed. exiting.
else
    echo "installing to the bottom of your .bash_profile"
    awsfunctionpath="$SCRIPTPATH/aws-functions.sh"
    echo "source $awsfunctionpath" >> $HOME/.bash_profile
fi