#!/bin/bash

for i in 'F' 'Cl' 'Br' 'I'; do
	for k in 'ip' 'op'; do
		cd G${i}_${k}
		
		rm E_fermi-${i}.txt
		rm E_total-${i}.txt
		
		printf "===== G${i}_${k} =====\n\n" | tee E_total-G${i}_${k}.txt
		printf "===== G${i}_${k} =====\n\n" | tee E_fermi-G${i}_${k}.txt
		
		for j in */; do
			cd $j
			
			printf "$j\n\t" | tee -a ../E_total-G${i}_${k}.txt
			printf "$j\n\t" | tee -a ../E_fermi-G${i}_${k}.txt
			
			less OUTPUT_*-scf | grep ! | tee -a ../E_total-G${i}_${k}.txt
			less OUTPUT_*-scf | grep Fermi | tee -a ../E_fermi-G${i}_${k}.txt
			
			printf "\n" | tee -a ../E_total-G${i}_${k}.txt
			printf "\n" | tee -a ../E_fermi-G${i}_${k}.txt
			
			cd ..
		done
		cd ..
	done
done
