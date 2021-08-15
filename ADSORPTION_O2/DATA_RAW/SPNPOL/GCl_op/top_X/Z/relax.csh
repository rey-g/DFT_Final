#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q std.q
#$ -N Cl_optx-Z
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_optx-Z-relax.in > OUTPUT_GCl_optx-Z-relax

# delete tmp
rm -r tmp/