#!/bin/bash

# cores; eg, 24
read -p 'Cores: ' K
# site; eg, B1
read -p 'Site [A/B1/B2]: ' S
# calc; eg, etc
read -p 'Calc [relax/etc]: ' c

cd $S
for i in */; do
	cd $i
	qsub -pe smp $K $c.csh
	cd .. # end GX_g
done
cd .. # end A/B1/B2
