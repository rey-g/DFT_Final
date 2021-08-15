#!/bin/bash

read -p 'Species: ' S

# for g in 'ip' 'op'; do
	# for X in 'F' 'Cl' 'Br' 'I'; do
		# cd G${X}_${g}
		# echo G${X}_${g}
		cd $S
		echo $S
		
		for j in */; do
			cd $j
			echo $j
			fname=$(basename ./*.cube .cube)
			
			bader_app -vac off ${fname}".cube"
			mv ACF.dat ${fname//_chgbader}"-ACF.dat"
			mv AVF.dat ${fname//_chgbader}"-AVF.dat"
			mv BCF.dat ${fname//_chgbader}"-BCF.dat"

			cd ..
		done	
		cd ..
	# done
# done
