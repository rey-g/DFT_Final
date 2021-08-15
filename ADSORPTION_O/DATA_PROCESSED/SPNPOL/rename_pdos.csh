#!/bin/bash

# read -p 'Species: ' i

for i in */; do
	cd $i
	echo $i
	
	for j in */; do
		cd $j/nscf
		echo $j
		
		for k in *.pdos_atm*; do
			el_pre=$(echo $k | grep -o -P '[(]([a-zA-Z]*)[)]' | head -1)
			el=$(echo ${el_pre} | grep -o -P '([a-zA-Z]*)')
			elno=$(echo $k | grep -o -P '([0-9]*)' | head -1)
			elno=${elno//#}
			
			orb_pre=$(echo $k | grep -o -P '[(]([a-zA-Z]*)[)]' | tail -1)
			orb=$(echo ${orb_pre} | grep -o -P '([a-z])')
			orbno=$(echo $k | grep -o -P '([0-9]*)' | tail -1)
			
			mv -v $k ${el}${elno}-${orbno}${orb}
		done
		cd ../..
	done
	cd ..
done

