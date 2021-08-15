#!/bin/bash

# calc; eg, etc
read -p 'Calc [relax/etc]: ' c
# cores; eg, 24
read -p 'Cores: ' K

for i in */; do
	cd $i
	qsub -pe mpi-$K $K $c.csh
	cd .. # end GX_g
done
