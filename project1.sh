cd "$1" 
if [ $? -eq 0 ] 
then 


echo -------------------------------------------
#------------------------------------------------------------------

#initializing the same,size of both largest and smallest file
    largestfile=" "
    largestfilesize=0
    smallestfile=" "
    smallestfilesize=100000000000000000


    ls -lR | grep "^[-]"> tmp.txt # romove all names of directories from output
    squeezedtext=$(tr -s " " < tmp.txt) #this will insure all whitespaces are removed
    echo "$squeezedtext" > tmp.txt #printing the squeezed text back to the same file
    
    cat tmp.txt | cut -d' ' -f9 > names.txt 
    cat names.txt | cut -d'.' -f2 > tmpextentions.txt
    sort tmpextentions.txt > extentions.txt 
    rm tmpextentions.txt
    uniq extentions.txt > uniq.txt
    uniq -c extentions.txt > uniqAndSize.txt

    #the following command is used to get the total disk size 
    diskSize=$(df -P | awk 'NR>2{sum+=$2}END{print sum}')
    #echo $diskSize
	while read p; do # while loop iterating on all lines of the tmp text file
	totalSize=0
	percentage=0
	Freq=0
	while read l; do

		name=$(echo "$l" | cut -d' ' -f9) # store the name of the content
		size=$(echo "$l" | cut -d' ' -f5  )
		type=$(echo "$name" | cut -d'.' -f2 )
		if [ $size -ge $largestfilesize ]
        	then 
        		largestfilesize=$size
        		largestfile=$name
        	fi

        	if [ $size -le $smallestfilesize -a $name != "tmp.txt" ]
        	then 
        		smallestfilesize=$size
        		smallestfile=$name
        	fi
		if [ "$type" == "$p" ]
		then
			totalSize=$(($totalSize+$size))
			Freq=$(($Freq+1))
		fi
	
	done < tmp.txt
	percentage=`bc -l <<< "$totalSize / $diskSize"`
	echo $p exists for $Freq times with total size $totalSize and percentage $percentage>> total.txt
    done < uniq.txt
 

    echo ————————————————————————————————————————> output.txt
    echo Directory Content Types,Occurances, Total size, Percentage on Disk  : >> output.txt
    echo ———————————————————————————————————————— >> output.txt
    cat total.txt >> output.txt 
    echo
    echo ———————————————————————————————————————— >> output.txt
    echo ———————————————————————————————————————— >> output.txt
    echo The file with largest size is:   $largestfile >> output.txt
    echo The file with smallest size is:   $smallestfile >> output.txt
    echo ———————————————————————————————————————— >> output.txt
    echo ———————————————————————————————————————— >> output.txt
    echo THANK YOU FOR USING MY PROGRAM >> output.txt
    echo     >> output.txt
    rm names.txt
    rm tmp.txt
    rm extentions.txt
    rm total.txt
    rm uniq.txt
    rm uniqAndSize.txt 
    
    #asking the user wether the output should be directed to the screen or to a txt file
    echo Would you like to have the output on a seperate file ?[y/n] 
    read answer #reading the answer of the user

    if [ $answer = "n" ] 
    then
	cat output.txt
	rm output.txt
    elif [ $answer = "y" ]
    then
	echo Check the folder
    else
	echo Incorrect input

    fi
else 
echo ERROR ! Check Directory name
fi