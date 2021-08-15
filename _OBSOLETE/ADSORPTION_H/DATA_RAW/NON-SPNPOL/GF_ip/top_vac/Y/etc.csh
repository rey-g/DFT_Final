#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N top_v-Y
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
echo started at `date`
mpirun -np $NSLOTS pw.x -inp INPUT_GF_iptv-Y-scf.in | tee OUTPUT_GF_iptv-Y-scf
echo finished at `date`

# pp
echo started at `date`
mpirun -np $NSLOTS pp.x -inp INPUT_GF_iptv-Y-pp.in | tee OUTPUT_GF_iptv-Y-pp
echo finished at `date` 

# bader
echo started at `date`
mpirun -np $NSLOTS pp.x -inp INPUT_GF_iptv-Y-bader.in | tee OUTPUT_GF_iptv-Y-bader
echo finished at `date` 

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
echo started at `date`
mpirun -np $NSLOTS pw.x -inp INPUT_GF_iptv-Y-nscf.in | tee OUTPUT_GF_iptv-Y-nscf
echo finished at `date`

# pdos
echo started at `date`
mpirun -np $NSLOTS projwfc.x -inp INPUT_GF_iptv-Y-pdos.in | tee OUTPUT_GF_iptv-Y-pdos
echo finished at `date` 

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
echo started at `date`
mpirun -np $NSLOTS pw.x -inp INPUT_GF_iptv-Y-bands1.in | tee OUTPUT_GF_iptv-Y-bands1
echo finished at `date`

# bands2
echo started at `date`
mpirun -np $NSLOTS bands.x -inp INPUT_GF_iptv-Y-bands2.in | tee OUTPUT_GF_iptv-Y-bands2
echo finished at `date`

# delete tmp
rm -r tmp/
