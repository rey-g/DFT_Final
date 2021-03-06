#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N I_optlh
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GI_optlh-scf.in > OUTPUT_GI_optlh-scf

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GI_optlh-pp-up.in > OUTPUT_GI_optlh-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_GI_optlh-pp-dn.in > OUTPUT_GI_optlh-pp-dn

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GI_optlh-bader.in > OUTPUT_GI_optlh-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GI_optlh-nscf.in > OUTPUT_GI_optlh-nscf

# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GI_optlh-pdos.in > OUTPUT_GI_optlh-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GI_optlh-bands1.in > OUTPUT_GI_optlh-bands1

# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GI_optlh-bands2-up.in > OUTPUT_GI_optlh-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_GI_optlh-bands2-dn.in > OUTPUT_GI_optlh-bands2-dn

# delete tmp
rm -r tmp/