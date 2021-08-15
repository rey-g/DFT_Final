#!/bin/bash

# copies ads/subs chgfiles
read -p 'Halogen [X]: ' X

cd SPNPOL
for g in 'ip' 'op'; do
	echo G${X}_${g}_as
	cd G${X}_${g}_as
	for i in */; do
		echo $i
		cp $i/*chg*.xsf -t ../../../DATA_PROCESSED/SPNPOL/G${X}_${g}/$i/
	done
	cd ..
done
cd ..
