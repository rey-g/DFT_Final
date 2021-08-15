#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVGB1-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVGB1-scf.in | tee OUTPUT_MVGB1-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVGB1-pp.in | tee OUTPUT_MVGB1-pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVGB1-pp-up.in | tee OUTPUT_MVGB1-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_MVGB1-pp-dn.in | tee OUTPUT_MVGB1-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVGB1-bader.in | tee OUTPUT_MVGB1-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVGB1-nscf.in | tee OUTPUT_MVGB1-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVGB1-pdos.in | tee OUTPUT_MVGB1-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVGB1-bands1.in | tee OUTPUT_MVGB1-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVGB1-bands2-up.in | tee OUTPUT_MVGB1-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVGB1-bands2-dn.in | tee OUTPUT_MVGB1-bands2-dn

rm -r tmp/

