#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N PG_txc-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_PG_txc-scf.in | tee OUTPUT_PG_txc-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_PG_txc-pp.in | tee OUTPUT_PG_txc-pp
mpirun -np $NSLOTS pp.x -inp INPUT_PG_txc-pp-up.in | tee OUTPUT_PG_txc-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_PG_txc-pp-dn.in | tee OUTPUT_PG_txc-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_PG_txc-bader.in | tee OUTPUT_PG_txc-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_PG_txc-nscf.in | tee OUTPUT_PG_txc-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_PG_txc-pdos.in | tee OUTPUT_PG_txc-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_PG_txc-bands1.in | tee OUTPUT_PG_txc-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_PG_txc-bands2-up.in | tee OUTPUT_PG_txc-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_PG_txc-bands2-dn.in | tee OUTPUT_PG_txc-bands2-dn

rm -r tmp/

