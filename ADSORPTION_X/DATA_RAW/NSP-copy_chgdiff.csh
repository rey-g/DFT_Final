#!/bin/bash

# THIS MUST BE RUN ONLY AFTER RUNNING
# NSP-copy_output.csh

# main
read -p 'Site [A/B1/B2/B3]_as: ' S

cd NON-SPNPOL

echo ${S}_as
cd ${S}_as
	
for i in */; do
	echo $i
	cp $i/*dens.xsf -t ../../../DATA_PROCESSED/NON-SPNPOL/$S/$i/
done
cd ..
cd ..
