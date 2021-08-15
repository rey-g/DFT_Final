#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_to-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_to-scf.in | tee OUTPUT_MVG_to-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_to-pp.in | tee OUTPUT_MVG_to-pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_to-pp-up.in | tee OUTPUT_MVG_to-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_to-pp-dn.in | tee OUTPUT_MVG_to-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_to-bader.in | tee OUTPUT_MVG_to-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_to-nscf.in | tee OUTPUT_MVG_to-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVG_to-pdos.in | tee OUTPUT_MVG_to-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_to-bands1.in | tee OUTPUT_MVG_to-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_to-bands2-up.in | tee OUTPUT_MVG_to-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_to-bands2-dn.in | tee OUTPUT_MVG_to-bands2-dn

rm -r tmp/

