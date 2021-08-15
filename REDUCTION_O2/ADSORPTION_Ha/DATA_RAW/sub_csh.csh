#!/bin/bash

# calc; eg, etc
read -p 'Calc [relax/etc]: ' c

for X in 'F' 'Cl' 'Br' 'I'; do
	for g in 'ip' 'op'; do
		cd G${X}_${g}
		sbatch $c.csh 
		cd ..
	done
done
