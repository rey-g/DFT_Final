#!/bin/bash

# type of calc
read -p 'SP/NSP: ' spn
read -p 'Halogen: ' X
read -p 'Geom: ' g
if [ $spn == 'SP' ]; then
	foldir='SPNPOL'
else
	foldir='NON-SPNPOL'
fi
mkdir -p ../DATA_PROCESSED/$foldir

cd $foldir
# for i in */; do
# for g in 'ip' 'op'; do
	echo G${X}_${g}
	mkdir -p ../../DATA_PROCESSED/$foldir/G${X}_${g} # GX_g
	
	cd G${X}_${g}
	for j in */; do
		echo ${j}
		mkdir -p ../../../DATA_PROCESSED/$foldir/G${X}_${g}/${j///} # top_s
		
		cd ${j}
		for k in */; do
			echo ${k}
			
			mkdir -p ../../../../DATA_PROCESSED/$foldir/G${X}_${g}/${j///}/${k///}
			mkdir -p ../../../../DATA_PROCESSED/$foldir/G${X}_${g}/${j///}/${k///}/nscf
			mkdir -p ../../../../DATA_PROCESSED/$foldir/G${X}_${g}/${j///}/${k///}/bands
		
			cp -v ${k}OUTPUT*relax* -t ../../../../DATA_PROCESSED/$foldir/G${X}_${g}/${j///}/${k///}
			cp -v ${k}*.xsf -t ../../../../DATA_PROCESSED/$foldir/G${X}_${g}/${j///}/${k///}
			cp -v ${k}*.cube -t ../../../../DATA_PROCESSED/$foldir/G${X}_${g}/${j///}/${k///}
			echo "pdos..."
			cp ${k}nscf/*.pdos_* -t ../../../../DATA_PROCESSED/$foldir/G${X}_${g}/${j///}//${k///}/nscf
			# cp -v ${k}bands/*.rap -t ../../../../DATA_PROCESSED/$foldir/G${X}_${g}/${j///}//${k///}bands
			# cp -v ${k}bands/*.gnu -t ../../../../DATA_PROCESSED/$foldir/G${X}_${g}/${j///}//${k///}bands
			cp -v ${k}bands/G*_bands* -t ../../../../DATA_PROCESSED/$foldir/G${X}_${g}/${j///}//${k///}/bands
		done
		cd ..
	done
	cd ..
# done
cd ..
