#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q std.q
#$ -N F_iptx-X
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GF_iptx-X-relax.in > OUTPUT_GF_iptx-X-relax

# delete tmp
rm -r tmp/