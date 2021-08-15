#!/bin/bash

# run_bader() {
			# ../../bader_app -vac off G${X}_${g}-${i}-bader.cube
			# mv ACF.dat ../G${X}_${g}-${i}-ACF.dat
			# mv AVF.dat ../G${X}_${g}-${i}-AVF.dat
			# mv BCF.dat ../G${X}_${g}-${i}-BCF.dat
# }

# main
mkdir -p ../DATA_PROCESSED/SPNPOL

cd SPNPOL
for i in */; do
	echo ${i}
	mkdir -p ../../DATA_PROCESSED/SPNPOL/${i///}
	mkdir -p ../../DATA_PROCESSED/SPNPOL/${i///}/nscf
	mkdir -p ../../DATA_PROCESSED/SPNPOL/${i///}/bands
	
	cp -v ${i}OUTPUT*relax* -t ../../DATA_PROCESSED/SPNPOL/${i///}
	cp -v ${i}*.xsf -t ../../DATA_PROCESSED/SPNPOL/${i///}
	cp -v ${i}*.cube -t ../../DATA_PROCESSED/SPNPOL/${i///}
	echo "pdos..."
	cp ${i}nscf/*.pdos_* -t ../../DATA_PROCESSED/SPNPOL/${i///}/nscf
	cp -v ${i}bands/G*-bands* -t ../../DATA_PROCESSED/SPNPOL/${i///}/bands
done
cd ..
