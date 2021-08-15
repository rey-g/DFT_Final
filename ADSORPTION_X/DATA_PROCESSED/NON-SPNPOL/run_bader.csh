#!/bin/bash

bader() {
	fname=$(basename ./*.cube .cube)
		
	bader_app -vac off ${fname}".cube"
	mv ACF.dat ${fname//bader}"ACF.dat"
	mv AVF.dat ${fname//bader}"AVF.dat"
	mv BCF.dat ${fname//bader}"BCF.dat"
}


# for S in 'A' 'B1' 'B2' 'B3' 'G_B1' 'G_B2' 'G_B3' 'MVG'; do
for S in 'B3'; do
	echo $S
	cd $S
	if [ $S == 'A' ] || [ $S == 'B1' ] || [ $S == 'B2' ] || [ $S == 'B3' ]; then
		for i in */; do
			cd $i
			echo $i
			bader
			cd ..
		done
	else
		bader
	fi
	cd ..
done
