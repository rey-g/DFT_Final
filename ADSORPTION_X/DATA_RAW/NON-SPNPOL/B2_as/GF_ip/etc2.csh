#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GF_ip-as
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np $NSLOTS pw.x -inp INPUT_ADS_GF_ip-B2-scf.in >  OUTPUT_ADS_GF_ip-B2-scf
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GF_ip-B2-pp.in >  OUTPUT_ADS_GF_ip-B2-pp
rm -r tmp_ads/

# SUBS
mpirun -np $NSLOTS pw.x -inp INPUT_SUBS_GF_ip-B2-scf.in >  OUTPUT_SUBS_GF_ip-B2-scf
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GF_ip-B2-pp.in >  OUTPUT_SUBS_GF_ip-B2-pp
rm -r tmp_subs/
