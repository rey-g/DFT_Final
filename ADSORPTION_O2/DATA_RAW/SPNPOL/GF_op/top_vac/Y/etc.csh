#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N F_optv-Y
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GF_optv-Y-scf.in > OUTPUT_GF_optv-Y-scf

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GF_optv-Y-pp-up.in > OUTPUT_GF_optv-Y-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_GF_optv-Y-pp-dn.in > OUTPUT_GF_optv-Y-pp-dn

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GF_optv-Y-bader.in > OUTPUT_GF_optv-Y-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GF_optv-Y-nscf.in > OUTPUT_GF_optv-Y-nscf

# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GF_optv-Y-pdos.in > OUTPUT_GF_optv-Y-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GF_optv-Y-bands1.in > OUTPUT_GF_optv-Y-bands1

# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GF_optv-Y-bands2-up.in > OUTPUT_GF_optv-Y-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_GF_optv-Y-bands2-dn.in > OUTPUT_GF_optv-Y-bands2-dn

# delete tmp
rm -r tmp/