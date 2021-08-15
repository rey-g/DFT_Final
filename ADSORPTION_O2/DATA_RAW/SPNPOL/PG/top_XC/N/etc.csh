#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N PG_txc-N-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_PG_txc-N-scf.in > OUTPUT_PG_txc-N-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_PG_txc-N-pp.in > OUTPUT_PG_txc-N-pp
mpirun -np $NSLOTS pp.x -inp INPUT_PG_txc-N-pp-up.in > OUTPUT_PG_txc-N-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_PG_txc-N-pp-dn.in > OUTPUT_PG_txc-N-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_PG_txc-N-bader.in > OUTPUT_PG_txc-N-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_PG_txc-N-nscf.in > OUTPUT_PG_txc-N-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_PG_txc-N-pdos.in > OUTPUT_PG_txc-N-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_PG_txc-N-bands1.in > OUTPUT_PG_txc-N-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_PG_txc-N-bands2-up.in > OUTPUT_PG_txc-N-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_PG_txc-N-bands2-dn.in > OUTPUT_PG_txc-N-bands2-dn

rm -r tmp/

