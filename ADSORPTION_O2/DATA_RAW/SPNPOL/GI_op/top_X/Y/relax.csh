#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q std.q
#$ -N I_optx-Y
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GI_optx-Y-relax.in > OUTPUT_GI_optx-Y-relax

# delete tmp
rm -r tmp/