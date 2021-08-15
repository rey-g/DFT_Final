#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N O2-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_O2-scf.in | tee OUTPUT_O2-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_O2-pp.in | tee OUTPUT_O2-pp
mpirun -np $NSLOTS pp.x -inp INPUT_O2-pp-up.in | tee OUTPUT_O2-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_O2-pp-dn.in | tee OUTPUT_O2-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_O2-bader.in | tee OUTPUT_O2-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_O2-nscf.in | tee OUTPUT_O2-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_O2-pdos.in | tee OUTPUT_O2-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_O2-bands1.in | tee OUTPUT_O2-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_O2-bands2-up.in | tee OUTPUT_O2-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_O2-bands2-dn.in | tee OUTPUT_O2-bands2-dn

rm -r tmp/

