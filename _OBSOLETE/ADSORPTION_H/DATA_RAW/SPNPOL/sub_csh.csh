#!/bin/bash

# halogen
read -p 'Halogen [F/Cl/Br/I]: ' X
# geometry
read -p '[ip/op]: ' g
# calc; eg, etc
read -p 'Calc [relax/etc]: ' c

cd G${X}_${g}
for j in */; do
	cd $j
	for i in */; do
		cd $i
		sbatch $c.csh
		cd .. # end X/Y/Z
	done
	cd ..
done
cd ..
