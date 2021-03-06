#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q std.q
#$ -N Br_optxc-Z
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_optxc-Z-relax.in > OUTPUT_GBr_optxc-Z-relax

# delete tmp
rm -r tmp/