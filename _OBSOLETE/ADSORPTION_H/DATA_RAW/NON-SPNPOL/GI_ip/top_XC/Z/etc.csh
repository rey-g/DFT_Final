#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -N top_xc-Z
#$ -q fast.q
#$ -V
#$ -M deleted@deleted.edu
#$ -m e

hostname
module load quantum-espresso/6.1

# scf
echo started at `date`
mpirun -np $NSLOTS pw.x -inp INPUT_GI_iptxc-Z-scf.in | tee OUTPUT_GI_iptxc-Z-scf
echo finished at `date`

# pp
echo started at `date`
mpirun -np $NSLOTS pp.x -inp INPUT_GI_iptxc-Z-pp.in | tee OUTPUT_GI_iptxc-Z-pp
echo finished at `date` 

# bader
echo started at `date`
mpirun -np $NSLOTS pp.x -inp INPUT_GI_iptxc-Z-bader.in | tee OUTPUT_GI_iptxc-Z-bader
echo finished at `date` 

# copy tmp folder
cp -r -v tmp/ nscf
cp -r -v tmp/ bands

# delete scf tmp
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
echo started at `date`
mpirun -np $NSLOTS pw.x -inp INPUT_GI_iptxc-Z-nscf.in | tee OUTPUT_GI_iptxc-Z-nscf
echo finished at `date`

# pdos
echo started at `date`
mpirun -np $NSLOTS projwfc.x -inp INPUT_GI_iptxc-Z-pdos.in | tee OUTPUT_GI_iptxc-Z-pdos
echo finished at `date` 

# delete nscf tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
echo started at `date`
mpirun -np $NSLOTS pw.x -inp INPUT_GI_iptxc-Z-bands1.in | tee OUTPUT_GI_iptxc-Z-bands1
echo finished at `date`

# bands2
echo started at `date`
mpirun -np $NSLOTS bands.x -inp INPUT_GI_iptxc-Z-bands2.in | tee OUTPUT_GI_iptxc-Z-bands2
echo finished at `date`

# delete bands tmp
rm -r tmp/