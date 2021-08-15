#!/bin/bash

# halogen
read -p 'Halogen [F/Cl/Br/I]: ' X

for g in 'ip' 'op'; do
	cd G${X}_${g}
	for j in */; do
		cd $j
		for i in */; do
			cd $i
			qsub -pe mpi-20 20 etc2.csh
			cd .. # end X/Y/Z
		done
		cd ..
	done
	cd ..
done
