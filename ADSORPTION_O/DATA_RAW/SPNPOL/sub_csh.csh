#!/bin/bash

# cores; eg, 24
read -p 'Cores: ' K
# calc; eg, etc
read -p 'Calc [relax/etc]: ' c

for i in */; do
	cd $i
	for j in */; do
		cd $j
		qsub -pe smp $K $c.csh
		cd .. # end top_s
	done
	cd .. # end GX_g
done
