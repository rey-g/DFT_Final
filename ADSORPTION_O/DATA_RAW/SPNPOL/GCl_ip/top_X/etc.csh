#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N Cl_iptx
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_iptx-scf.in > OUTPUT_GCl_iptx-scf

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GCl_iptx-pp-up.in > OUTPUT_GCl_iptx-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_GCl_iptx-pp-dn.in > OUTPUT_GCl_iptx-pp-dn

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GCl_iptx-bader.in > OUTPUT_GCl_iptx-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_iptx-nscf.in > OUTPUT_GCl_iptx-nscf

# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GCl_iptx-pdos.in > OUTPUT_GCl_iptx-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_iptx-bands1.in > OUTPUT_GCl_iptx-bands1

# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GCl_iptx-bands2-up.in > OUTPUT_GCl_iptx-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_GCl_iptx-bands2-dn.in > OUTPUT_GCl_iptx-bands2-dn

# delete tmp
rm -r tmp/