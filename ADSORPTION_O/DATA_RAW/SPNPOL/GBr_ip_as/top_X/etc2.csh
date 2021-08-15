#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GBr_iptx
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np $NSLOTS pw.x -inp INPUT_ADS_GBr_iptx-scf.in >  OUTPUT_ADS_GBr_iptx-scf
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GBr_iptx-pp-up.in >  OUTPUT_ADS_GBr_iptx-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GBr_iptx-pp-dn.in >  OUTPUT_ADS_GBr_iptx-pp-dn
rm -r tmp_ads/

# SUBS
mpirun -np $NSLOTS pw.x -inp INPUT_SUBS_GBr_iptx-scf.in >  OUTPUT_SUBS_GBr_iptx-scf
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GBr_iptx-pp-up.in >  OUTPUT_SUBS_GBr_iptx-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GBr_iptx-pp-dn.in >  OUTPUT_SUBS_GBr_iptx-pp-dn
rm -r tmp_subs/
