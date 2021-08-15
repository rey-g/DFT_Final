#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N PG_txc-Z-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_PG_txc-Z-scf.in > OUTPUT_PG_txc-Z-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_PG_txc-Z-pp.in > OUTPUT_PG_txc-Z-pp
mpirun -np $NSLOTS pp.x -inp INPUT_PG_txc-Z-pp-up.in > OUTPUT_PG_txc-Z-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_PG_txc-Z-pp-dn.in > OUTPUT_PG_txc-Z-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_PG_txc-Z-bader.in > OUTPUT_PG_txc-Z-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_PG_txc-Z-nscf.in > OUTPUT_PG_txc-Z-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_PG_txc-Z-pdos.in > OUTPUT_PG_txc-Z-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_PG_txc-Z-bands1.in > OUTPUT_PG_txc-Z-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_PG_txc-Z-bands2-up.in > OUTPUT_PG_txc-Z-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_PG_txc-Z-bands2-dn.in > OUTPUT_PG_txc-Z-bands2-dn

rm -r tmp/

