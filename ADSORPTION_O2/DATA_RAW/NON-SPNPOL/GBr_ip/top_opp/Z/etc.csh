#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N top_o-Z
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
echo started at `date`
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_ipto-Z-scf.in | tee OUTPUT_GBr_ipto-Z-scf
echo finished at `date`

# pp
echo started at `date`
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_ipto-Z-pp.in | tee OUTPUT_GBr_ipto-Z-pp
echo finished at `date` 

# bader
echo started at `date`
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_ipto-Z-bader.in | tee OUTPUT_GBr_ipto-Z-bader
echo finished at `date` 

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
echo started at `date`
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_ipto-Z-nscf.in | tee OUTPUT_GBr_ipto-Z-nscf
echo finished at `date`

# pdos
echo started at `date`
mpirun -np $NSLOTS projwfc.x -inp INPUT_GBr_ipto-Z-pdos.in | tee OUTPUT_GBr_ipto-Z-pdos
echo finished at `date` 

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
echo started at `date`
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_ipto-Z-bands1.in | tee OUTPUT_GBr_ipto-Z-bands1
echo finished at `date`

# bands2
echo started at `date`
mpirun -np $NSLOTS bands.x -inp INPUT_GBr_ipto-Z-bands2.in | tee OUTPUT_GBr_ipto-Z-bands2
echo finished at `date`

# delete tmp
rm -r tmp/
