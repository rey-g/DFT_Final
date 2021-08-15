#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG-scf.in | tee OUTPUT_MVG-scf

cp -r tmp/ -t bands/
rm -r tmp/

cd bands/

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG-bands1.in | tee OUTPUT_MVG-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG-bands2.in | tee OUTPUT_MVG-bands2

rm -r tmp/

