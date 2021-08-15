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
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_op-A-scf.in | tee OUTPUT_GBr_op-A-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_op-A-pp.in | tee OUTPUT_GBr_op-A-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_op-A-bader.in | tee OUTPUT_GBr_op-A-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_op-A-nscf.in | tee OUTPUT_GBr_op-A-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GBr_op-A-pdos.in | tee OUTPUT_GBr_op-A-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_op-A-bands1.in | tee OUTPUT_GBr_op-A-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GBr_op-A-bands2.in | tee OUTPUT_GBr_op-A-bands2

rm -r tmp/

