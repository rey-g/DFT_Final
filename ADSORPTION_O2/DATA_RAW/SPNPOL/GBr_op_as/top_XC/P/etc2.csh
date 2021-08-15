#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GBr_optxc-P
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np $NSLOTS pw.x -inp INPUT_ADS_GBr_optxc-P-scf.in >  OUTPUT_ADS_GBr_optxc-P-scf
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GBr_optxc-P-pp-up.in >  OUTPUT_ADS_GBr_optxc-P-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GBr_optxc-P-pp-dn.in >  OUTPUT_ADS_GBr_optxc-P-pp-dn
rm -r tmp_ads/

# SUBS
mpirun -np $NSLOTS pw.x -inp INPUT_SUBS_GBr_optxc-P-scf.in >  OUTPUT_SUBS_GBr_optxc-P-scf
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GBr_optxc-P-pp-up.in >  OUTPUT_SUBS_GBr_optxc-P-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GBr_optxc-P-pp-dn.in >  OUTPUT_SUBS_GBr_optxc-P-pp-dn
rm -r tmp_subs/
