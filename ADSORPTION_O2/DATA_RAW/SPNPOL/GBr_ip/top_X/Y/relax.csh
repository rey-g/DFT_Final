#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q std.q
#$ -N Br_iptx-Y
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_iptx-Y-relax.in > OUTPUT_GBr_iptx-Y-relax

# delete tmp
rm -r tmp/