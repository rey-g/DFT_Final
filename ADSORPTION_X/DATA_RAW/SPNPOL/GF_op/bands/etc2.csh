#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GF_op
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
cd ..
mpirun -np $NSLOTS pw.x -inp INPUT_GF_op-B1-scf.in > OUTPUT_GF_op-B1-scf

# copy tmp folder
cp -r tmp/ bands
rm -r tmp/

# chdir to bands dir
cd bands/

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GF_op-B1-bands1.in > OUTPUT_GF_op-B1-bands1

# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GF_op-B1-bands2-up.in > OUTPUT_GF_op-B1-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_GF_op-B1-bands2-dn.in > OUTPUT_GF_op-B1-bands2-dn

# delete tmp
rm -r tmp/