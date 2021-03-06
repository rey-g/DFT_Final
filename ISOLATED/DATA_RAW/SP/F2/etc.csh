#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N F2-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_F2-scf.in | tee OUTPUT_F2-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_F2-pp.in | tee OUTPUT_F2-pp
mpirun -np $NSLOTS pp.x -inp INPUT_F2-pp-up.in | tee OUTPUT_F2-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_F2-pp-dn.in | tee OUTPUT_F2-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_F2-bader.in | tee OUTPUT_F2-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_F2-nscf.in | tee OUTPUT_F2-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_F2-pdos.in | tee OUTPUT_F2-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_F2-bands1.in | tee OUTPUT_F2-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_F2-bands2-up.in | tee OUTPUT_F2-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_F2-bands2-dn.in | tee OUTPUT_F2-bands2-dn

rm -r tmp/

