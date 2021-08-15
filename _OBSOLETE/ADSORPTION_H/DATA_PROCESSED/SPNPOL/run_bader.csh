#!/bin/bash

read -p 'Halogen: ' X

for g in 'ip' 'op'; do
	cd G${X}_${g}
	echo G${X}_${g}
	for j in */; do
		cd $j
		echo $j
		for k in */; do
			cd $k
			echo $k
			fname=$(basename ./*.cube .cube)
			
			bader_app -vac off ${fname}".cube"
			mv ACF.dat ${fname//_chgbader}"-ACF.dat"
			mv AVF.dat ${fname//_chgbader}"-AVF.dat"
			mv BCF.dat ${fname//_chgbader}"-BCF.dat"
			
			cd ..
		done
		cd ..
	done	
	cd ..
done
