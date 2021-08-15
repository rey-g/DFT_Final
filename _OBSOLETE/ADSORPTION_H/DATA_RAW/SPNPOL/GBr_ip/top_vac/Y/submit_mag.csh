#!/bin/bash

for g in '0.1' '0.2' '0.3' '0.4' '0.5' '0.6' '0.7' '0.8' '0.9' '1.0'; do
	cd ${g}
	qsub -pe mpi-24 24 relax.csh
	cd ..
done
