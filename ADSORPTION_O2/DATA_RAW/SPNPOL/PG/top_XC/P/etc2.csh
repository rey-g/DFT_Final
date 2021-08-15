#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N PG_txc-P-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_PG_txc-P-nscf.in > OUTPUT_PG_txc-P-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_PG_txc-P-pdos.in > OUTPUT_PG_txc-P-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_PG_txc-P-bands1.in > OUTPUT_PG_txc-P-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_PG_txc-P-bands2-up.in > OUTPUT_PG_txc-P-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_PG_txc-P-bands2-dn.in > OUTPUT_PG_txc-P-bands2-dn

rm -r tmp/

