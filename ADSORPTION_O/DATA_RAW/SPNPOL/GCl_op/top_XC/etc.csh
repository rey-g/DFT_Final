#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N Cl_optxc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_optxc-scf.in > OUTPUT_GCl_optxc-scf

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GCl_optxc-pp-up.in > OUTPUT_GCl_optxc-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_GCl_optxc-pp-dn.in > OUTPUT_GCl_optxc-pp-dn

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GCl_optxc-bader.in > OUTPUT_GCl_optxc-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_optxc-nscf.in > OUTPUT_GCl_optxc-nscf

# pdos
mpirun -np $NSLOTS projwfc.x -inp INPUT_GCl_optxc-pdos.in > OUTPUT_GCl_optxc-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_optxc-bands1.in > OUTPUT_GCl_optxc-bands1

# bands2
mpirun -np $NSLOTS bands.x -inp INPUT_GCl_optxc-bands2-up.in > OUTPUT_GCl_optxc-bands2-up
mpirun -np $NSLOTS bands.x -inp INPUT_GCl_optxc-bands2-dn.in > OUTPUT_GCl_optxc-bands2-dn

# delete tmp
rm -r tmp/