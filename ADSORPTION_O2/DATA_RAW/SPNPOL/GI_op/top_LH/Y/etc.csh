#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N I_optlh-Y
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GI_optlh-Y-scf.in > OUTPUT_GI_optlh-Y-scf

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GI_optlh-Y-pp-up.in > OUTPUT_GI_optlh-Y-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_GI_optlh-Y-pp-dn.in > OUTPUT_GI_optlh-Y-pp-dn

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GI_optlh-Y-bader.in > OUTPUT_GI_optlh-Y-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GI_optlh-Y-nscf.in > OUTPUT_GI_optlh-Y-nscf

# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GI_optlh-Y-pdos.in > OUTPUT_GI_optlh-Y-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GI_optlh-Y-bands1.in > OUTPUT_GI_optlh-Y-bands1

# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GI_optlh-Y-bands2-up.in > OUTPUT_GI_optlh-Y-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_GI_optlh-Y-bands2-dn.in > OUTPUT_GI_optlh-Y-bands2-dn

# delete tmp
rm -r tmp/