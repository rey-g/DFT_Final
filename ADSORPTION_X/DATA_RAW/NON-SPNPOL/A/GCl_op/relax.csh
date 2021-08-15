#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GCl_op-relax
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

mpirun -np $NSLOTS pw.x -inp INPUT_GCl_op-A-relax.in | tee OUTPUT_GCl_op-A-relax

rm -r tmp/

