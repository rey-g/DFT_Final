#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N C-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_C-scf.in | tee OUTPUT_C-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_C-pp.in | tee OUTPUT_C-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_C-bader.in | tee OUTPUT_C-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_C-nscf.in | tee OUTPUT_C-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_C-pdos.in | tee OUTPUT_C-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_C-bands1.in | tee OUTPUT_C-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_C-bands2.in | tee OUTPUT_C-bands2

rm -r tmp/

