#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N F_iptlh
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GF_iptlh-scf.in > OUTPUT_GF_iptlh-scf

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GF_iptlh-pp-up.in > OUTPUT_GF_iptlh-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_GF_iptlh-pp-dn.in > OUTPUT_GF_iptlh-pp-dn

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GF_iptlh-bader.in > OUTPUT_GF_iptlh-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GF_iptlh-nscf.in > OUTPUT_GF_iptlh-nscf

# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GF_iptlh-pdos.in > OUTPUT_GF_iptlh-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GF_iptlh-bands1.in > OUTPUT_GF_iptlh-bands1

# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GF_iptlh-bands2-up.in > OUTPUT_GF_iptlh-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_GF_iptlh-bands2-dn.in > OUTPUT_GF_iptlh-bands2-dn

# delete tmp
rm -r tmp/