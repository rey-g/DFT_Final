#!/bin/bash

for i in */; do
	cd $i
	
	printf "===== SYSTEM ${i///} =====\n\n" > E_total-${i///}.txt
	
	for j in */; do
		cd $j
		
		printf "$j\n\t" >> ../E_total-${i///}.txt
		less OUTPUT_*-scf | grep ! >> ../E_total-${i///}.txt
		printf "\n" >> ../E_total-${i///}.txt

		cd ..
	done
	cd ..
done
