#! /bin/bash

read -p 'Halogen [X]: ' X

cd G$X
for h in */; do
	cd $h
	qsub -pe mpi-20 20 conv_${h///}.csh
	cd ..
done
cd ..
