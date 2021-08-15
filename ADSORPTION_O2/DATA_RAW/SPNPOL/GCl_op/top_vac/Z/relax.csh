#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q std.q
#$ -N Cl_optv-Z
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_optv-Z-relax.in > OUTPUT_GCl_optv-Z-relax

# delete tmp
rm -r tmp/