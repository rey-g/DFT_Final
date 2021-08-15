#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N Br_ipto
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_ipto-scf.in > OUTPUT_GBr_ipto-scf

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_ipto-pp-up.in > OUTPUT_GBr_ipto-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_ipto-pp-dn.in > OUTPUT_GBr_ipto-pp-dn

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_ipto-bader.in > OUTPUT_GBr_ipto-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_ipto-nscf.in > OUTPUT_GBr_ipto-nscf

# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GBr_ipto-pdos.in > OUTPUT_GBr_ipto-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_ipto-bands1.in > OUTPUT_GBr_ipto-bands1

# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GBr_ipto-bands2-up.in > OUTPUT_GBr_ipto-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_GBr_ipto-bands2-dn.in > OUTPUT_GBr_ipto-bands2-dn

# delete tmp
rm -r tmp/