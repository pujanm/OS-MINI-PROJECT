#!/bin/bash
if [ "$*" == "" ]; then
	echo "Please enter a STOCK Ticker."
	exit 1
fi
if curl -f  https://www.quandl.com/api/v3/datasets/WIKI/$1.csv --output $1.csv --silent ; then
    	k=0
	open=0
	close=0
	latesto=0
	latestc=0
	latestoamz=0
	latestcamz=0
	s1=0
	s2=0
	#read -p "Enter the stock name : " name
	curl -s  https://www.quandl.com/api/v3/datasets/WIKI/$1.csv --output $1.csv --silent
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
	
	
	#echo "$s"
	open=`echo $s1 / $k | bc`
	close=`echo $s2 / $k | bc`
	echo "The average opening price of $1 stocks is $open."
else 
	echo "STOCK Ticker is Invalid"
	exit 1
fi
k=0
curl -s  https://www.quandl.com/api/v3/datasets/WIKI/GOOGL.csv --output GOOGL.csv --silent
while IFS=,  read -r f1 f2 f3 f4 f5 f6 f7
do
	if (( $k == 1 )) 
	then
		latesto=$f2
		latestc=$f5
		date=$f1
	fi
	(( k++ ))
done < GOOGL.csv
k=0
curl -s  https://www.quandl.com/api/v3/datasets/WIKI/AAPL.csv --output AAPL.csv --silent
while IFS=,  read -r f1 f2 f3 f4 f5 f6 f7
do
	if (( $k == 1 )) 
	then
		latestoamz=$f2
		latestcamz=$f5
		dateamz=$f1
	fi
	(( k++ ))
done < AAPL.csv
zenity --info --text="		GOOGLE STOCK\nThe latest opening price i.e. at date $date of GOOGL stocks is $latesto\n		APPLE STOCK\nThe latest opening price i.e. at date $dateamz of AAPL stocks is $latestoamz"
