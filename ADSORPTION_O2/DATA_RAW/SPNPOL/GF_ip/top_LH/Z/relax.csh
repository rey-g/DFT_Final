#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q std.q
#$ -N F_iptlh-Z
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GF_iptlh-Z-relax.in > OUTPUT_GF_iptlh-Z-relax

# delete tmp
rm -r tmp/