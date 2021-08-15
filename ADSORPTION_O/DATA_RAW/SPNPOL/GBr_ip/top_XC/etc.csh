#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N Br_iptxc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_iptxc-scf.in > OUTPUT_GBr_iptxc-scf

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_iptxc-pp-up.in > OUTPUT_GBr_iptxc-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_iptxc-pp-dn.in > OUTPUT_GBr_iptxc-pp-dn

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_iptxc-bader.in > OUTPUT_GBr_iptxc-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_iptxc-nscf.in > OUTPUT_GBr_iptxc-nscf

# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GBr_iptxc-pdos.in > OUTPUT_GBr_iptxc-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_iptxc-bands1.in > OUTPUT_GBr_iptxc-bands1

# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GBr_iptxc-bands2-up.in > OUTPUT_GBr_iptxc-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_GBr_iptxc-bands2-dn.in > OUTPUT_GBr_iptxc-bands2-dn

# delete tmp
rm -r tmp/