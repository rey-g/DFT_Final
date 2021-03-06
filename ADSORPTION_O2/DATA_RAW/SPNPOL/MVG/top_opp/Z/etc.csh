#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_to-Z-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_to-Z-scf.in > OUTPUT_MVG_to-Z-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_to-Z-pp.in > OUTPUT_MVG_to-Z-pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_to-Z-pp-up.in > OUTPUT_MVG_to-Z-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_to-Z-pp-dn.in > OUTPUT_MVG_to-Z-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_to-Z-bader.in > OUTPUT_MVG_to-Z-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_to-Z-nscf.in > OUTPUT_MVG_to-Z-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVG_to-Z-pdos.in > OUTPUT_MVG_to-Z-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_to-Z-bands1.in > OUTPUT_MVG_to-Z-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_to-Z-bands2-up.in > OUTPUT_MVG_to-Z-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_to-Z-bands2-dn.in > OUTPUT_MVG_to-Z-bands2-dn

rm -r tmp/

