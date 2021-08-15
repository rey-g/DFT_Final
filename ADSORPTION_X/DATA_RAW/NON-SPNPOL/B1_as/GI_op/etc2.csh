#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GI_op-as
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np $NSLOTS pw.x -inp INPUT_ADS_GI_op-B1-scf.in >  OUTPUT_ADS_GI_op-B1-scf
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GI_op-B1-pp.in >  OUTPUT_ADS_GI_op-B1-pp
rm -r tmp_ads/

# SUBS
mpirun -np $NSLOTS pw.x -inp INPUT_SUBS_GI_op-B1-scf.in >  OUTPUT_SUBS_GI_op-B1-scf
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GI_op-B1-pp.in >  OUTPUT_SUBS_GI_op-B1-pp
rm -r tmp_subs/
