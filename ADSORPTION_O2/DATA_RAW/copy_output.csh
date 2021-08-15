#!/bin/bash

# type of calc
read -p 'SP/NSP: ' spn
if [ $spn == 'SP' ]; then
	foldir='SPNPOL'
else
	foldir='NON-SPNPOL'
fi
mkdir -p ../DATA_PROCESSED/$foldir

cd $foldir
for i in */; do
	echo ${i}
	mkdir -p ../../DATA_PROCESSED/$foldir/${i///} # GX_g
	
	cd ${i}
	for j in */; do
		echo ${j}
		mkdir -p ../../../DATA_PROCESSED/$foldir/${i///}/${j///} # top_s
		
		cd ${j}
		for k in */; do
			echo ${k}
			
			mkdir -p ../../../../DATA_PROCESSED/$foldir/${i///}/${j///}/${k///}
			mkdir -p ../../../../DATA_PROCESSED/$foldir/${i///}/${j///}/${k///}/nscf
			mkdir -p ../../../../DATA_PROCESSED/$foldir/${i///}/${j///}/${k///}/bands
		
			cp -v ${k}OUTPUT*relax* -t ../../../../DATA_PROCESSED/$foldir/${i///}/${j///}/${k///}
			cp -v ${k}*.xsf -t ../../../../DATA_PROCESSED/$foldir/${i///}/${j///}/${k///}
			cp -v ${k}*.cube -t ../../../../DATA_PROCESSED/$foldir/${i///}/${j///}/${k///}
			echo "pdos..."
			cp ${k}nscf/*.pdos_* -t ../../../../DATA_PROCESSED/$foldir/${i///}/${j///}//${k///}/nscf
			# cp -v ${k}bands/*.rap -t ../../../../DATA_PROCESSED/$foldir/${i///}/${j///}//${k///}bands
			# cp -v ${k}bands/*.gnu -t ../../../../DATA_PROCESSED/$foldir/${i///}/${j///}//${k///}bands
			cp -v ${k}bands/G*_bands* -t ../../../../DATA_PROCESSED/$foldir/${i///}/${j///}//${k///}/bands
		done
		cd ..
	done
	cd ..
done
cd ..
