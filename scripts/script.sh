#!/usr/bin/env bash

export LC_ALL=C

echo "  ___   ___  ____    ___   ____   _____ "
echo " (  _( / _( /  _ \  )_ _( )  _)\ )__ __("
echo " _) \  ))_  )  ' /  _| |_ | '__/   | |  "
echo ")____) \__( |_()_\ )_____()_(      )_(  "
echo

if [[ "$OSTYPE" == *"linux"* ]]; then

  if [[ $EUID -ne 0 ]]; then

    echo
    #sudo /usr/sbin/./iftop

  else

    echo
    #/usr/sbin/./iftop

  fi

fi

if [[ "$OSTYPE" == *"darwin"* ]]; then

  if [[ $EUID -ne 0 ]]; then

    echo
    #sudo /usr/local/sbin/./iftop -i $(ACTIVE=$(ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active') && echo ${ACTIVE:0:3})
    #sudo /usr/local/sbin/./iftop

  else

    echo
    #/usr/local/sbin/./iftop -i $(ACTIVE=$(ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active') && echo ${ACTIVE:0:3})
    #/usr/local/sbin/./iftop

  fi

fi

echo "OSTYPE = $OSTYPE"
