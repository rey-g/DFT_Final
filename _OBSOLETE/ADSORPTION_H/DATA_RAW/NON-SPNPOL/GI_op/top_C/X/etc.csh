#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -N top_c-X
#$ -q fast.q
#$ -V
#$ -M deleted@deleted.edu
#$ -m e

hostname
module load quantum-espresso/6.1

# scf
echo started at `date`
mpirun -np $NSLOTS pw.x -inp INPUT_GI_optc-X-scf.in | tee OUTPUT_GI_optc-X-scf
echo finished at `date`

# pp
echo started at `date`
mpirun -np $NSLOTS pp.x -inp INPUT_GI_optc-X-pp.in | tee OUTPUT_GI_optc-X-pp
echo finished at `date` 

# bader
echo started at `date`
mpirun -np $NSLOTS pp.x -inp INPUT_GI_optc-X-bader.in | tee OUTPUT_GI_optc-X-bader
echo finished at `date` 

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# delete scf tmp
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
echo started at `date`
mpirun -np $NSLOTS pw.x -inp INPUT_GI_optc-X-nscf.in | tee OUTPUT_GI_optc-X-nscf
echo finished at `date`

# pdos
echo started at `date`
mpirun -np $NSLOTS projwfc.x -inp INPUT_GI_optc-X-pdos.in | tee OUTPUT_GI_optc-X-pdos
echo finished at `date` 

# delete nscf tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
echo started at `date`
mpirun -np $NSLOTS pw.x -inp INPUT_GI_optc-X-bands1.in | tee OUTPUT_GI_optc-X-bands1
echo finished at `date`

# bands2
echo started at `date`
mpirun -np $NSLOTS bands.x -inp INPUT_GI_optc-X-bands2.in | tee OUTPUT_GI_optc-X-bands2
echo finished at `date`

# delete bands tmp
rm -r tmp/