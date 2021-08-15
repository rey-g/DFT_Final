#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N HOOH-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_HOOH-scf.in | tee OUTPUT_HOOH-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_HOOH-pp.in | tee OUTPUT_HOOH-pp
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_HOOH-bader.in | tee OUTPUT_HOOH-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_HOOH-nscf.in | tee OUTPUT_HOOH-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_HOOH-pdos.in | tee OUTPUT_HOOH-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_HOOH-bands1.in | tee OUTPUT_HOOH-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_HOOH-bands2.in | tee OUTPUT_HOOH-bands2

rm -r tmp/

