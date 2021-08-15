#!/bin/bash

# cores; eg, 24
read -p 'Cores: ' K
# calc; eg, etc
read -p 'Calc [relax/etc]: ' c

for i in */; do
	cd $i
	qsub -pe smp $K $c.csh
	cd .. # end GX_g
done
