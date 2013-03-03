#!/bin/bash
ttyport=/dev/ttyUSB0
stty -F $ttyport 38400
echo c > $ttyport
sleep 1
echo "schreibe Giess-o-mat output aus $ttyport in giess.csv"
cat $ttyport > giess.csv

