#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GBr_iptv-Z
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np $NSLOTS pw.x -inp INPUT_ADS_GBr_iptv-Z-scf.in >  OUTPUT_ADS_GBr_iptv-Z-scf
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GBr_iptv-Z-pp-up.in >  OUTPUT_ADS_GBr_iptv-Z-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GBr_iptv-Z-pp-dn.in >  OUTPUT_ADS_GBr_iptv-Z-pp-dn
rm -r tmp_ads/

# SUBS
mpirun -np $NSLOTS pw.x -inp INPUT_SUBS_GBr_iptv-Z-scf.in >  OUTPUT_SUBS_GBr_iptv-Z-scf
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GBr_iptv-Z-pp-up.in >  OUTPUT_SUBS_GBr_iptv-Z-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GBr_iptv-Z-pp-dn.in >  OUTPUT_SUBS_GBr_iptv-Z-pp-dn
rm -r tmp_subs/
