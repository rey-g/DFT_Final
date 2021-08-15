#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N I_iptc-Z
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GI_iptc-Z-scf.in > OUTPUT_GI_iptc-Z-scf

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GI_iptc-Z-pp-up.in > OUTPUT_GI_iptc-Z-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_GI_iptc-Z-pp-dn.in > OUTPUT_GI_iptc-Z-pp-dn

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GI_iptc-Z-bader.in > OUTPUT_GI_iptc-Z-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GI_iptc-Z-nscf.in > OUTPUT_GI_iptc-Z-nscf

# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GI_iptc-Z-pdos.in > OUTPUT_GI_iptc-Z-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GI_iptc-Z-bands1.in > OUTPUT_GI_iptc-Z-bands1

# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GI_iptc-Z-bands2-up.in > OUTPUT_GI_iptc-Z-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_GI_iptc-Z-bands2-dn.in > OUTPUT_GI_iptc-Z-bands2-dn

# delete tmp
rm -r tmp/