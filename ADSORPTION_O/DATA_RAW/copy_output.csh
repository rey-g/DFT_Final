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
	mkdir -p ../../DATA_PROCESSED/$foldir/${i///}
	
	cd ${i}
	for j in */; do
		echo ${j}
		mkdir -p ../../../DATA_PROCESSED/$foldir/${i///}/${j///}
		mkdir -p ../../../DATA_PROCESSED/$foldir/${i///}/${j///}/nscf
		mkdir -p ../../../DATA_PROCESSED/$foldir/${i///}/${j///}/bands
		
		cp ${j}OUTPUT*relax* -t ../../../DATA_PROCESSED/$foldir/${i///}/${j///}
		cp ${j}*.xsf -t ../../../DATA_PROCESSED/$foldir/${i///}/${j///}
		cp ${j}*.cube -t ../../../DATA_PROCESSED/$foldir/${i///}/${j///}
		cp ${j}nscf/*.pdos_* -t ../../../DATA_PROCESSED/$foldir/${i///}/${j///}/nscf
		# cp ${j}bands/*.rap -t ../../../DATA_PROCESSED/$foldir/${i///}/${j///}/bands
		# cp ${j}bands/*.gnu -t ../../../DATA_PROCESSED/$foldir/${i///}/${j///}/bands
		cp ${j}bands/G*bands* -t ../../../DATA_PROCESSED/$foldir/${i///}/${j///}/bands
	done
	cd ..
done
cd ..
