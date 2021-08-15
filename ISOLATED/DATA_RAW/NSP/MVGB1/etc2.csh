#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVGB1-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVGB1-scf.in | tee OUTPUT_MVGB1-scf

cp -r tmp/ -t bands/
rm -r tmp/

cd bands/

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVGB1-bands1.in | tee OUTPUT_MVGB1-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVGB1-bands2.in | tee OUTPUT_MVGB1-bands2

rm -r tmp/

