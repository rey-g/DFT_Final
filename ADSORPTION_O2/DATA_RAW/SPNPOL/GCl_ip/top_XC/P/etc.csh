#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N Cl_iptxc-P
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_iptxc-P-scf.in > OUTPUT_GCl_iptxc-P-scf

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GCl_iptxc-P-pp-up.in > OUTPUT_GCl_iptxc-P-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_GCl_iptxc-P-pp-dn.in > OUTPUT_GCl_iptxc-P-pp-dn

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GCl_iptxc-P-bader.in > OUTPUT_GCl_iptxc-P-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_iptxc-P-nscf.in > OUTPUT_GCl_iptxc-P-nscf

# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GCl_iptxc-P-pdos.in > OUTPUT_GCl_iptxc-P-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_iptxc-P-bands1.in > OUTPUT_GCl_iptxc-P-bands1

# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GCl_iptxc-P-bands2-up.in > OUTPUT_GCl_iptxc-P-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_GCl_iptxc-P-bands2-dn.in > OUTPUT_GCl_iptxc-P-bands2-dn

# delete tmp
rm -r tmp/