#!/bin/bash

count=99
titcount=99
giessdata=$(cat giess.csv | tr ";" "\n" | tr -d "\r" ) 
for data1 in $giessdata 
do
  if [ $data1 = "#S" ] || [ $data1 = "#P" ]; then
  	 count=0
  	 tag1=$data1
  else
     count=$((count+1))
    	 
    if [ $count -eq 1 ]; then
      date1="'$data1"
    elif [ $count -eq 2 ]; then
      date1="$date1 $data1'"
    elif [ $count -lt 9 ]; then
      idx=$((count-2))
      if [ $tag1 = "#S" ]; then
        line[idx]="${line[idx]},[$date1,$data1]"
      elif [ $data1 != "0" ]; then
        pump[idx]="${pump[idx]},[$date1,$data1]"
        lastpump[idx]=$data1
      fi
    fi
  fi  
    
  if [ $data1 = "Zeit" ]; then
  	 titcount=0
  elif [ $titcount -lt 7 ]; then
     titcount=$((titcount+1)) 
     title[titcount]=$data1
  fi
done

echo "function getSensorData(Index) {" 
for i in {1..6}
do
  echo "if(Index == $i) { return [${line[$i]:1}]; }"
done
echo "}"

echo "function getPumpData(Index) {" 
for i in {1..6}
do
  echo "if(Index == $i) { return [${pump[$i]:1},[$date1,${lastpump[$i]}]]; }"
done
echo "}"

echo "function getTitle(Index) {" 
for i in {1..6}
do
  echo "if(Index == $i) { return '${title[$i]}'; }"
done
echo "}"
