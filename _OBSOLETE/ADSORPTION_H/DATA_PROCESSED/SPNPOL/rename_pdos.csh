#!/bin/bash

for i in */; do
	cd $i
	echo $i
	
	for j in */; do
		cd $j
		echo $j
		
		for k in */; do
			cd $k/nscf
			echo $k
		
			for l in *.pdos_atm*; do
				el_pre=$(echo $l | grep -o -P '[(]([a-zA-Z]*)[)]' | head -1)
				el=$(echo ${el_pre} | grep -o -P '([a-zA-Z]*)')
				elno=$(echo $l | grep -o -P '([0-9]*)' | head -1)
				
				orb_pre=$(echo $l | grep -o -P '[(]([a-zA-Z]*)[)]' | tail -1)
				orb=$(echo ${orb_pre} | grep -o -P '([a-z])')
				orbno=$(echo $l | grep -o -P '([0-9]*)' | tail -1)
				
				mv -v $l ${el}${elno}-${orbno}${orb}
			done
			cd ../..
		done
		cd ..
	done
	cd ..
done
