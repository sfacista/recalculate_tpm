#!/bin/bash
# This script re-calculates all the TPM values for all .sf files in the working directory. I got this from Kevin Drenner, but modified it for my own purposes. I believe the awk code originates from the lab of Dr. Jonathan Keats

ls *.sf > calc_file_list_temp

while read list_item
	do
		# Calculate SUM of number of reads divided by Effective length for TPM calculation
		TPMSUM=$(awk -F'\t' 'BEGIN { SUM = 0 } NR > 1 { SUM = SUM + ($5/$3)} END { print SUM }' ${list_item})

		#Recalculate TPM for each ENST
		awk -F'\t' -v TPMSUM=${TPMSUM} 'NR == 1 { OFS = "\t" ; print $0 } ; NR > 1 { OFS = "\t" ; $4 = 1000000 * ( $5 / $3 ) / TPMSUM ; print $0 } ' $list_item > recalculated_${list_item}
	done < calc_file_list_temp

#echo rm
rm calc_file_list_temp