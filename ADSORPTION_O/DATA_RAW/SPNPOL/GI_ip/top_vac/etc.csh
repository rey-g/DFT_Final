#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N I_iptv
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GI_iptv-scf.in > OUTPUT_GI_iptv-scf

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GI_iptv-pp-up.in > OUTPUT_GI_iptv-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_GI_iptv-pp-dn.in > OUTPUT_GI_iptv-pp-dn

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GI_iptv-bader.in > OUTPUT_GI_iptv-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GI_iptv-nscf.in > OUTPUT_GI_iptv-nscf

# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GI_iptv-pdos.in > OUTPUT_GI_iptv-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GI_iptv-bands1.in > OUTPUT_GI_iptv-bands1

# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GI_iptv-bands2-up.in > OUTPUT_GI_iptv-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_GI_iptv-bands2-dn.in > OUTPUT_GI_iptv-bands2-dn

# delete tmp
rm -r tmp/