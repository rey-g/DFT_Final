#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q std.q
#$ -N MVG_ip
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_ip-B1-relax.in > OUTPUT_MVG_ip-B1-relax

# delete tmp
rm -r tmp/