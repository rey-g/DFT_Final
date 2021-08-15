#!/bin/bash

for X in 'F' 'Cl' 'Br' 'I'; do
	for g in 'ip' 'op'; do
		cd G${X}_${g}
		for s in 'C' 'LH' 'opp' 'vac' 'X' 'XC'; do		
			cd top_${s}
			
			mv etc.csh etc2.csh

			cd ..
		done
		cd ..
	done
done
cd ..
