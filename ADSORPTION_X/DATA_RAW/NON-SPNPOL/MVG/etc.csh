#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG-scf.in | tee OUTPUT_MVG-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG-pp.in | tee OUTPUT_MVG-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVG-bader.in | tee OUTPUT_MVG-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG-nscf.in | tee OUTPUT_MVG-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVG-pdos.in | tee OUTPUT_MVG-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG-bands1.in | tee OUTPUT_MVG-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG-bands2.in | tee OUTPUT_MVG-bands2

rm -r tmp/

