#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GI_op-relax
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

mpirun -np $NSLOTS pw.x -inp INPUT_GI_op-B1-relax.in | tee OUTPUT_GI_op-B1-relax

rm -r tmp/

