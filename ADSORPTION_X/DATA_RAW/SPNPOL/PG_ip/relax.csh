#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q std.q
#$ -N PG_ip
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_PG_ip-B1-relax.in > OUTPUT_PG_ip-B1-relax

# delete tmp
rm -r tmp/