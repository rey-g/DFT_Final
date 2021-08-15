#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GF-5.0
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

mpirun -np $NSLOTS pw.x -inp INPUT_GF-B3-5.0-scf.in | tee OUTPUT_GF-B3-5.0-scf

rm -r tmp/

