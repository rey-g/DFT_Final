#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_tc-Z-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tc-Z-scf.in > OUTPUT_MVG_tc-Z-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tc-Z-pp.in > OUTPUT_MVG_tc-Z-pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tc-Z-pp-up.in > OUTPUT_MVG_tc-Z-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tc-Z-pp-dn.in > OUTPUT_MVG_tc-Z-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_tc-Z-bader.in > OUTPUT_MVG_tc-Z-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tc-Z-nscf.in > OUTPUT_MVG_tc-Z-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVG_tc-Z-pdos.in > OUTPUT_MVG_tc-Z-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_tc-Z-bands1.in > OUTPUT_MVG_tc-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tc-Z-bands2-up.in > OUTPUT_MVG_tc-Z-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_tc-Z-bands2-dn.in > OUTPUT_MVG_tc-Z-bands2-dn

rm -r tmp/

