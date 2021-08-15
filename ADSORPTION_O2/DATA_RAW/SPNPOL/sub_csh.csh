#!/bin/bash

# halogen
read -p 'Halogen [F/Cl/Br/I]: ' X
# calc; eg, etc
read -p 'Calc [relax/etc]: ' c

if [ $c == 'relax' ]; then
	k=24
else
	k=20
fi

for g in 'ip' 'op'; do
	cd G${X}_${g}
	for j in */; do
		cd $j
		for i in */; do
			cd $i
			qsub -pe mpi-${k} $k $c.csh
			cd .. # end X/Y/Z
		done
		cd ..
	done
	cd ..
done
