#!/bin/bash

for i in */; do
	cd $i/bands
	qsub -pe mpi-20 20 etc2.csh
	cd ../.. # end GX_g/bands
done
