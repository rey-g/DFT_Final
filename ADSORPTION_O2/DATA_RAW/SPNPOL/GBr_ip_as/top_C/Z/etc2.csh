#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GBr_iptc-Z
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np $NSLOTS pw.x -inp INPUT_ADS_GBr_iptc-Z-scf.in >  OUTPUT_ADS_GBr_iptc-Z-scf
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GBr_iptc-Z-pp-up.in >  OUTPUT_ADS_GBr_iptc-Z-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GBr_iptc-Z-pp-dn.in >  OUTPUT_ADS_GBr_iptc-Z-pp-dn
rm -r tmp_ads/

# SUBS
mpirun -np $NSLOTS pw.x -inp INPUT_SUBS_GBr_iptc-Z-scf.in >  OUTPUT_SUBS_GBr_iptc-Z-scf
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GBr_iptc-Z-pp-up.in >  OUTPUT_SUBS_GBr_iptc-Z-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GBr_iptc-Z-pp-dn.in >  OUTPUT_SUBS_GBr_iptc-Z-pp-dn
rm -r tmp_subs/
