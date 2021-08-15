#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_tv-Y-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

cd nscf/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tv-Y-bands1.in > OUTPUT_MVG_tv-Y-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tv-Y-bands2-up.in > OUTPUT_MVG_tv-Y-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tv-Y-bands2-dn.in > OUTPUT_MVG_tv-Y-bands2-dn

rm -r tmp/

