#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_tv-X-relax
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tv-X-relax.in > OUTPUT_MVG_tv-X-relax

rm -r tmp/

