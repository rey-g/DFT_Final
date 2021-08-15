#!/bin/bash

read -p 'Sign [neg/pos]: ' s

tar -xzvf $s.tar.gz 
cd $s
for g in */; do
	cd ${g}
	qsub -pe mpi-24 24 -q fast.q relax.csh
	cd ..
done
cd ..
