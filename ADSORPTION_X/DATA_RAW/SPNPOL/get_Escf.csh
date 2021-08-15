#!/bin/bash

rm E_fermi.txt
rm E_total.txt

for i in 'F' 'Cl' 'Br' 'I'; do
	for k in 'ip' 'op'; do
		printf "===== G${i}_${k} =====\n\n" >> E_total.txt
		printf "===== G${i}_${k} =====\n\n" >> E_fermi.txt
		
		cd G${i}_${k}
		less OUTPUT_*-scf | grep ! >> ../E_total.txt
		less OUTPUT_*-scf | grep Fermi >> ../E_fermi.txt
		printf "\n" >> ../E_total.txt
		printf "\n" >> ../E_fermi.txt
		
		cd ..
	done
done
