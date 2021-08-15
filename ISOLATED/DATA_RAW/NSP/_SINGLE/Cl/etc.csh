#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N Cl-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_Cl-scf.in | tee OUTPUT_Cl-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_Cl-pp.in | tee OUTPUT_Cl-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_Cl-bader.in | tee OUTPUT_Cl-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_Cl-nscf.in | tee OUTPUT_Cl-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_Cl-pdos.in | tee OUTPUT_Cl-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_Cl-bands1.in | tee OUTPUT_Cl-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_Cl-bands2.in | tee OUTPUT_Cl-bands2

rm -r tmp/

