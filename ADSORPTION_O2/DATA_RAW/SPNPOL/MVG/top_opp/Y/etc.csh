#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N MVG_to-Y-etc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_to-Y-scf.in > OUTPUT_MVG_to-Y-scf
# pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_to-Y-pp.in > OUTPUT_MVG_to-Y-pp
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_to-Y-pp-up.in > OUTPUT_MVG_to-Y-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_to-Y-pp-dn.in > OUTPUT_MVG_to-Y-pp-dn
# bader
mpirun -np $NSLOTS pp.x -inp INPUT_MVG_to-Y-bader.in > OUTPUT_MVG_to-Y-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_to-Y-nscf.in > OUTPUT_MVG_to-Y-nscf
# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_MVG_to-Y-pdos.in > OUTPUT_MVG_to-Y-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_MVG_to-Y-bands1.in > OUTPUT_MVG_to-Y-bands1
# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_to-Y-bands2-up.in > OUTPUT_MVG_to-Y-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_MVG_to-Y-bands2-dn.in > OUTPUT_MVG_to-Y-bands2-dn

rm -r tmp/

