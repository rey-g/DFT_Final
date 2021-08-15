#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N O-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_O-scf.in | tee OUTPUT_O-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_O-pp.in | tee OUTPUT_O-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_O-bader.in | tee OUTPUT_O-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_O-nscf.in | tee OUTPUT_O-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_O-pdos.in | tee OUTPUT_O-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_O-bands1.in | tee OUTPUT_O-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_O-bands2.in | tee OUTPUT_O-bands2

rm -r tmp/

