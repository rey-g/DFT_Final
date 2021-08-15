#!/bin/bash

# halogen
read -p 'Halogen [F/Cl/Br/I]: ' X
# calc; eg, etc
read -p 'Calc [relax/etc]: ' c
# geometry
read -p '[ip/op]: ' g

cd G${X}_${g}
for j in */; do
	cd $j
	for i in */; do
		cd $i
		qsub -pe mpi-24 24 $c.csh
		cd .. # end X/Y/Z
	done
	cd ..
done
cd ..
