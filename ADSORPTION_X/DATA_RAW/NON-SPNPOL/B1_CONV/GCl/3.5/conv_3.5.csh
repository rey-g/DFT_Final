#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GCl-3.5
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

mpirun -np $NSLOTS pw.x -inp INPUT_GCl-B1-3.5-scf.in | tee OUTPUT_GCl-B1-3.5-scf

rm -r tmp/

