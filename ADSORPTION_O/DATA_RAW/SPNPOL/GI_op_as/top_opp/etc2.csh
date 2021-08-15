#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GI_opto
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np $NSLOTS pw.x -inp INPUT_ADS_GI_opto-scf.in >  OUTPUT_ADS_GI_opto-scf
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GI_opto-pp-up.in >  OUTPUT_ADS_GI_opto-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GI_opto-pp-dn.in >  OUTPUT_ADS_GI_opto-pp-dn
rm -r tmp_ads/

# SUBS
mpirun -np $NSLOTS pw.x -inp INPUT_SUBS_GI_opto-scf.in >  OUTPUT_SUBS_GI_opto-scf
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GI_opto-pp-up.in >  OUTPUT_SUBS_GI_opto-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GI_opto-pp-dn.in >  OUTPUT_SUBS_GI_opto-pp-dn
rm -r tmp_subs/
