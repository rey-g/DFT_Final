#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N HOH-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_HOH-scf.in | tee OUTPUT_HOH-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_HOH-pp.in | tee OUTPUT_HOH-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_HOH-bader.in | tee OUTPUT_HOH-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_HOH-nscf.in | tee OUTPUT_HOH-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_HOH-pdos.in | tee OUTPUT_HOH-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_HOH-bands1.in | tee OUTPUT_HOH-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_HOH-bands2.in | tee OUTPUT_HOH-bands2

rm -r tmp/

