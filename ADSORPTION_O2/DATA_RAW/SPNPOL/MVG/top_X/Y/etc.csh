#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_tx-Y-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tx-Y-scf.in > OUTPUT_MVG_tx-Y-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tx-Y-pp.in > OUTPUT_MVG_tx-Y-pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tx-Y-pp-up.in > OUTPUT_MVG_tx-Y-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tx-Y-pp-dn.in > OUTPUT_MVG_tx-Y-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tx-Y-bader.in > OUTPUT_MVG_tx-Y-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tx-Y-nscf.in > OUTPUT_MVG_tx-Y-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVG_tx-Y-pdos.in > OUTPUT_MVG_tx-Y-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tx-Y-bands1.in > OUTPUT_MVG_tx-Y-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tx-Y-bands2-up.in > OUTPUT_MVG_tx-Y-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tx-Y-bands2-dn.in > OUTPUT_MVG_tx-Y-bands2-dn

rm -r tmp/

