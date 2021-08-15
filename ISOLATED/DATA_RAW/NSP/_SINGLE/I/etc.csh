#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N I-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_I-scf.in | tee OUTPUT_I-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_I-pp.in | tee OUTPUT_I-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_I-bader.in | tee OUTPUT_I-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_I-nscf.in | tee OUTPUT_I-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_I-pdos.in | tee OUTPUT_I-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_I-bands1.in | tee OUTPUT_I-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_I-bands2.in | tee OUTPUT_I-bands2

rm -r tmp/

