#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q std.q
#$ -N Cl_iptlh-Y
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_iptlh-Y-relax.in > OUTPUT_GCl_iptlh-Y-relax

# delete tmp
rm -r tmp/