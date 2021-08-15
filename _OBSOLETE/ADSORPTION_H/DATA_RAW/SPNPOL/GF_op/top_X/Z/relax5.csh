#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q long.q
#$ -N F_optx-Z
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GF_optx-Z-relax5.in > OUTPUT_GF_optx-Z-relax5

# delete tmp
rm -r tmp/