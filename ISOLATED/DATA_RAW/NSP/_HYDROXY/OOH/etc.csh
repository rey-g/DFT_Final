#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N OOH-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_OOH-scf.in | tee OUTPUT_OOH-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_OOH-pp.in | tee OUTPUT_OOH-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_OOH-bader.in | tee OUTPUT_OOH-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_OOH-nscf.in | tee OUTPUT_OOH-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_OOH-pdos.in | tee OUTPUT_OOH-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_OOH-bands1.in | tee OUTPUT_OOH-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_OOH-bands2.in | tee OUTPUT_OOH-bands2

rm -r tmp/

