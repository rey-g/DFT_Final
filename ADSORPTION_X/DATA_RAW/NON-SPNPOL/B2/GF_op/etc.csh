#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GF_op-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GF_op-B2-scf.in | tee OUTPUT_GF_op-B2-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GF_op-B2-pp.in | tee OUTPUT_GF_op-B2-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GF_op-B2-bader.in | tee OUTPUT_GF_op-B2-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GF_op-B2-nscf.in | tee OUTPUT_GF_op-B2-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GF_op-B2-pdos.in | tee OUTPUT_GF_op-B2-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GF_op-B2-bands1.in | tee OUTPUT_GF_op-B2-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GF_op-B2-bands2.in | tee OUTPUT_GF_op-B2-bands2

rm -r tmp/

