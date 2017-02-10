#!/bin/bash 

PROGNAME=$(basename $0)
function error_exit
{
    echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
    exit 1
}

echo "Enter the file name"
read name

INPUT=$name.csv
echo

ncol=`head -1 $INPUT | sed 's/[^,]//g' | wc -c`
#echo $ncol
nrow=`cat $INPUT | wc -l`
#echo $nrow

re='^[0-9]+$'
usum=
asum=

uflag=
aflag=
i=1
while [ $i -le $ncol ]; do
Col=( $(cut -d ',' -f$i $INPUT ) )
#printf "%s\n" "${Col[0]}"

if [ "${Col[0]}" = "Unit" ]; then
	#echo ${Col[1]}
	uflag=1
j=1
while [ $j -le $nrow ];
do
	if [[ ${Col[j]} =~ $re ]];
        then
	usum=$(($usum + ${Col[j]}))
	fi
	let j++
done 
	echo "The Sum of Unit: $usum"
	#echo "The column Unit is not present"
fi
if [ "${Col[0]}" = "Amount" ]; then
	#echo ${Col[1]}
	aflag=1
k=1
while [ $k -le $nrow ];
do
	if [[ ${Col[k]} =~ $re ]];
        then
	asum=$(($asum + ${Col[k]}))
	fi
	let k++
done
	printf "The Sum of Amount: \$%'.2f\n" $asum
	#echo "The Sum of Amount: \$$asum"
fi
let i++
done
echo

if [ -z "$uflag" ] && [ -z "$aflag" ] 
then
	error_exit "$LINENO: both columns Unit and Amount is not found."
	#echo "The column \"Unit\" and \"Amount\" is not present." 1>&2
	#exit 1
else
{ if [ -z $uflag ] 
then
	error_exit "$LINENO: column Unit is not found."
	#echo "The column \"Unit\" is not present." 1>&2
	#exit 1
fi
if [ -z $aflag ] 
then
	error_exit "$LINENO: column Amount is not found."
	#echo "The column \"Amount\" is not present." 1>&2
	#exit 1
fi }
fi
