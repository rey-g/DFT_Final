#!/bin/bash

# run_bader() {
			# ../../bader_app -vac off G${X}_${g}-${S}-bader.cube
			# mv ACF.dat ../G${X}_${g}-${S}-ACF.dat
			# mv AVF.dat ../G${X}_${g}-${S}-AVF.dat
			# mv BCF.dat ../G${X}_${g}-${S}-BCF.dat
# }

# main
mkdir -p ../DATA_PROCESSED/NON-SPNPOL
cd NON-SPNPOL

# A/B1/B2/B3
for S in 'A/' 'B1/' 'B2/' 'B3/'; do
	echo ${S}
	mkdir -p ../../DATA_PROCESSED/NON-SPNPOL/${S///}
	
	cd ${S}
	for i in 'GBr_op/' 'GCl_op/' 'GF_op/' 'GI_op/'; do #GX_g
		echo ${i}
		mkdir -p ../../../DATA_PROCESSED/NON-SPNPOL/${S///}/${i///}
		mkdir -p ../../../DATA_PROCESSED/NON-SPNPOL/${S///}/${i///}/bands
		mkdir -p ../../../DATA_PROCESSED/NON-SPNPOL/${S///}/${i///}/nscf
		
		cp -v ${i}OUTPUT*relax* -t ../../../DATA_PROCESSED/NON-SPNPOL/${S///}/${i///}
		cp -v ${i}*.xsf -t ../../../DATA_PROCESSED/NON-SPNPOL/${S///}/${i///}
		cp -v ${i}*.cube -t ../../../DATA_PROCESSED/NON-SPNPOL/${S///}/${i///}
		echo "pdos..."
		cp ${i}nscf/*.pdos_* -t ../../../DATA_PROCESSED/NON-SPNPOL/${S///}/${i///}/nscf
		cp -v ${i}bands/G*-bands* -t ../../../DATA_PROCESSED/NON-SPNPOL/${S///}/${i///}/bands
	done
	cd ..
done

# others
# for S in 'MVG/' 'G_B1/' 'G_B2/' 'G_B3/'; do
# for S in 'G_B1/' 'G_B2/' 'G_B3/'; do
	# echo ${S}
	# mkdir -p ../../DATA_PROCESSED/NON-SPNPOL/${S///}
	
	# mkdir -p ../../DATA_PROCESSED/NON-SPNPOL/${S///}
	# mkdir -p ../../DATA_PROCESSED/NON-SPNPOL/${S///}/bands
	# mkdir -p ../../DATA_PROCESSED/NON-SPNPOL/${S///}/nscf
		
	# cp -v ${S}OUTPUT*relax* -t ../../DATA_PROCESSED/NON-SPNPOL/${S///}
	# cp -v ${S}*.xsf -t ../../DATA_PROCESSED/NON-SPNPOL/${S///}
	# cp -v ${S}*.cube -t ../../DATA_PROCESSED/NON-SPNPOL/${S///}
	# echo "pdos..."
	# cp ${S}nscf/*.pdos_* -t ../../DATA_PROCESSED/NON-SPNPOL/${S///}/nscf
	# cp -v ${S}bands/${S///}-bands* -t ../../DATA_PROCESSED/NON-SPNPOL/${S///}/bands
# done

cd ..
