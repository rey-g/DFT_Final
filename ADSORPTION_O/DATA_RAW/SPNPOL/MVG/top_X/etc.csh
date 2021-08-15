#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_tx-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tx-scf.in | tee OUTPUT_MVG_tx-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tx-pp.in | tee OUTPUT_MVG_tx-pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tx-pp-up.in | tee OUTPUT_MVG_tx-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tx-pp-dn.in | tee OUTPUT_MVG_tx-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tx-bader.in | tee OUTPUT_MVG_tx-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tx-nscf.in | tee OUTPUT_MVG_tx-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVG_tx-pdos.in | tee OUTPUT_MVG_tx-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tx-bands1.in | tee OUTPUT_MVG_tx-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tx-bands2-up.in | tee OUTPUT_MVG_tx-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tx-bands2-dn.in | tee OUTPUT_MVG_tx-bands2-dn

rm -r tmp/

