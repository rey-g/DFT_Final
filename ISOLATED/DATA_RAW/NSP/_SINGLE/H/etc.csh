#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N H-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_H-scf.in | tee OUTPUT_H-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_H-pp.in | tee OUTPUT_H-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_H-bader.in | tee OUTPUT_H-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_H-nscf.in | tee OUTPUT_H-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_H-pdos.in | tee OUTPUT_H-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_H-bands1.in | tee OUTPUT_H-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_H-bands2.in | tee OUTPUT_H-bands2

rm -r tmp/

