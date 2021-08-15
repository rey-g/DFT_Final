#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_tc-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tc-scf.in | tee OUTPUT_MVG_tc-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tc-pp.in | tee OUTPUT_MVG_tc-pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tc-pp-up.in | tee OUTPUT_MVG_tc-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tc-pp-dn.in | tee OUTPUT_MVG_tc-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tc-bader.in | tee OUTPUT_MVG_tc-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tc-nscf.in | tee OUTPUT_MVG_tc-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVG_tc-pdos.in | tee OUTPUT_MVG_tc-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tc-bands1.in | tee OUTPUT_MVG_tc-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tc-bands2-up.in | tee OUTPUT_MVG_tc-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tc-bands2-dn.in | tee OUTPUT_MVG_tc-bands2-dn

rm -r tmp/

