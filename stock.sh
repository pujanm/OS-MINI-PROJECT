#!/bin/bash
if [ "$*" == "" ]; then
	echo "Please enter a STOCK Ticker."
	exit 1
fi
if curl -f  https://www.quandl.com/api/v3/datasets/WIKI/$1.csv --output $1.csv --silent ; then
    	k=0
	open=0
	close=0
	s1=0
	latesto=0
	latestc=0
	date=""
	s2=0
	#read -p "Enter the stock name : " name
	curl -s  https://www.quandl.com/api/v3/datasets/WIKI/$1.csv --output $1.csv --silent
	curl -s  https://www.quandl.com/api/v3/datasets/WIKI/NFLX.csv --output NFLX.csv --silent
	while IFS=,  read -r f1 f2 f3 f4 f5 f6 f7
	do
		if (( $k != 0 )) 
		then
			#echo "$f2"
			#echo $f1 | awk -F'-' '{print $3}'
			s1=`echo $s1 + $f2 | bc`
			s2=`echo $s2 + $f5 | bc`
		fi
		(( k++ ))

	done < $1.csv
	
	while IFS=,  read -r f1 f2 f3 f4 f5 f6 f7
	do
		if (( $k != 0 )) 
		then
			#echo "$f2"
			#echo $f1 | awk -F'-' '{print $3}'
			s1=`echo $s1 + $f2 | bc`
			s2=`echo $s2 + $f5 | bc`
		else
			latesto=$f2
			latestc=$f5
			date=$f1
		fi
		(( k++ ))

	done < NFLX.csv
	#echo "$s"
	open=`echo $s1 / $k | bc`
	close=`echo $s2 / $k | bc`
	echo "The average opening price of $1 stocks is $open."
	rm -rf $1.csv
else 
	echo "STOCK Ticker is Invalid"
	exit 1
fi
zenity --info --text="|_____NETFLIX STOCK______| \n The latest opening price i.e. at date $date of $1 stocks is $latesto"
