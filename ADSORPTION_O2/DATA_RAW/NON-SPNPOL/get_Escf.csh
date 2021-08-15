#!/bin/bash
# gets final and fermi energies

for X in 'F' 'Cl' 'Br' 'I'; do
	for g in 'ip' 'op'; do
		cd G${X}_${g}
		
		rm FermiE-*
		rm TotalE-*
		
		printf 'G'${X}'_'${g}'\n' >> FermiE-NSP-G${X}_${g}.txt
		printf 'G'${X}'_'${g}'\n' >> TotalE-NSP-G${X}_${g}.txt
		
		for i in */; do
			cd $i
			
			printf '\n'${i}'\n' >> ../FermiE-NSP-G${X}_${g}.txt
			printf '\n'${i}'\n' >> ../TotalE-NSP-G${X}_${g}.txt
			
			for j in */; do
				cd $j

				printf ${j}':\t' >> ../../FermiE-NSP-G${X}_${g}.txt
				printf ${j}':\t' >> ../../TotalE-NSP-G${X}_${g}.txt
				
				less OUTPUT_G${X}*-scf | grep Fermi >> ../../FermiE-NSP-G${X}_${g}.txt
				less OUTPUT_G${X}*-scf | grep ! >> ../../TotalE-NSP-G${X}_${g}.txt

				
				cd .. # end X/Y/Z
			done
			cd .. # end top_s
		done
		cd .. # end GX_g
	done
done
