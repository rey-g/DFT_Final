#!/bin/bash

read -p 'System: ' S

cd $S
if [ $S == 'A' ] || [ $S == 'B1' ] || [ $S == 'B2' ] || [ $S == 'B3' ]; then
	for i in */; do
		cd $i
		cd nscf
		for k in *.pdos_atm*; do
			el_pre=$(echo $k | grep -o -P '[(]([a-zA-Z]*)[)]' | head -1)
			el=$(echo ${el_pre} | grep -o -P '([a-zA-Z]*)')
			elno=$(echo $k | grep -o -P '([0-9]*)' | head -1)
					
			orb_pre=$(echo $k | grep -o -P '[(]([a-zA-Z]*)[)]' | tail -1)
			orb=$(echo ${orb_pre} | grep -o -P '([a-z])')
			orbno=$(echo $k | grep -o -P '([0-9]*)' | tail -1)
					
			mv -v $k ${el}${elno}-${orbno}${orb}
		done
		cd ../..
	done
else
	cd nscf
	for k in *.pdos_atm*; do
		el_pre=$(echo $k | grep -o -P '[(]([a-zA-Z]*)[)]' | head -1)
		el=$(echo ${el_pre} | grep -o -P '([a-zA-Z]*)')
		if [ $S == 'MVG' ]; then 
			elno=$(echo $k | grep -o -P '([0-9]*)' | head -1)
		else
			elno=$(echo $k | grep -o -P '[#]([0-9]*)' | head -1)
			elno=$(echo $elno | grep -o -P '([0-9]*)')
		fi
		
		orb_pre=$(echo $k | grep -o -P '[(]([a-zA-Z]*)[)]' | tail -1)
		orb=$(echo ${orb_pre} | grep -o -P '([a-z])')
		orbno=$(echo $k | grep -o -P '([0-9]*)' | tail -1)
					
		mv -v $k ${el}${elno}-${orbno}${orb}
	done

	cd ..
fi
cd ..