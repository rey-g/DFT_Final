#!/bin/bash

# for i in 'A' 'B1' 'B2'; do
for i in 'B3'; do
	cd $i
	
	printf "===== SITE $i =====\n\n" > E_total-$i.txt
	printf "===== SITE $i =====\n\n" > E_fermi-$i.txt
	
	for j in */; do
		cd $j
		
		printf "$j\n\t" >> ../E_total-$i.txt
		printf "$j\n\t" >> ../E_fermi-$i.txt
		
		less OUTPUT_*-scf | grep ! >> ../E_total-$i.txt
		less OUTPUT_*-scf | grep Fermi >> ../E_fermi-$i.txt
		
		printf "\n" >> ../E_total-$i.txt
		printf "\n" >> ../E_fermi-$i.txt
		
		cd ..
	done
	cd ..
done
