#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GBr_op-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_op-B3-scf.in | tee OUTPUT_GBr_op-B3-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_op-B3-pp.in | tee OUTPUT_GBr_op-B3-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_op-B3-bader.in | tee OUTPUT_GBr_op-B3-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_op-B3-nscf.in | tee OUTPUT_GBr_op-B3-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GBr_op-B3-pdos.in | tee OUTPUT_GBr_op-B3-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_op-B3-bands1.in | tee OUTPUT_GBr_op-B3-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GBr_op-B3-bands2.in | tee OUTPUT_GBr_op-B3-bands2

rm -r tmp/

