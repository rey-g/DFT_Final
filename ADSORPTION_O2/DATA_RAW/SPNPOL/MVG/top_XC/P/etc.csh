#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_txc-P-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_txc-P-scf.in > OUTPUT_MVG_txc-P-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_txc-P-pp.in > OUTPUT_MVG_txc-P-pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_txc-P-pp-up.in > OUTPUT_MVG_txc-P-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_txc-P-pp-dn.in > OUTPUT_MVG_txc-P-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_txc-P-bader.in > OUTPUT_MVG_txc-P-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_txc-P-nscf.in > OUTPUT_MVG_txc-P-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVG_txc-P-pdos.in > OUTPUT_MVG_txc-P-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_txc-P-bands1.in > OUTPUT_MVG_txc-P-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_txc-P-bands2-up.in > OUTPUT_MVG_txc-P-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_txc-P-bands2-dn.in > OUTPUT_MVG_txc-P-bands2-dn

rm -r tmp/

