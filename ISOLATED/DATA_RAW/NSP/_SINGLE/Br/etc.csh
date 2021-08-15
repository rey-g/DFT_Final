#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N Br-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_Br-scf.in | tee OUTPUT_Br-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_Br-pp.in | tee OUTPUT_Br-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_Br-bader.in | tee OUTPUT_Br-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_Br-nscf.in | tee OUTPUT_Br-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_Br-pdos.in | tee OUTPUT_Br-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_Br-bands1.in | tee OUTPUT_Br-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_Br-bands2.in | tee OUTPUT_Br-bands2

rm -r tmp/

