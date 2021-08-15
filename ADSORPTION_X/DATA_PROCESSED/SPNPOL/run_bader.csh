#!/bin/bash

for g in 'ip' 'op'; do
	for X in 'F' 'Cl' 'Br' 'I'; do
		cd G${X}_${g}
		
		fname=$(basename ./*.cube .cube)
		
		bader_app -vac off ${fname}".cube"
		mv ACF.dat ${fname//bader}"ACF.dat"
		mv AVF.dat ${fname//bader}"AVF.dat"
		mv BCF.dat ${fname//bader}"BCF.dat"
			
		cd ..
	done
done
