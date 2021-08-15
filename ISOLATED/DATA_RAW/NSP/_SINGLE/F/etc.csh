#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N F-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_F-scf.in | tee OUTPUT_F-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_F-pp.in | tee OUTPUT_F-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_F-bader.in | tee OUTPUT_F-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_F-nscf.in | tee OUTPUT_F-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_F-pdos.in | tee OUTPUT_F-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_F-bands1.in | tee OUTPUT_F-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_F-bands2.in | tee OUTPUT_F-bands2

rm -r tmp/

