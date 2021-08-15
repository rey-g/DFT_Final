#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q std.q
#$ -N Br_optv
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_optv-relax.in > OUTPUT_GBr_optv-relax

# delete tmp
rm -r tmp/