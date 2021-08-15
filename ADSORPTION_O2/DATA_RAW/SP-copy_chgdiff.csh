#!/bin/bash

# copies ads/subs chgfiles
read -p 'Halogen [X]: ' X

cd SPNPOL
for g in 'ip' 'op'; do
	echo G${X}_${g}_as
	cd G${X}_${g}_as
	for i in */; do
		cd $i
		for j in */; do
			echo $i-$j
			cp $j/*chg*.xsf -t ../../../../DATA_PROCESSED/SPNPOL/G${X}_${g}/$i/$j
		done
		cd ..
	done
	cd ..
done
cd ..
