#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GF_optxc-N
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np $NSLOTS pw.x -inp INPUT_ADS_GF_optxc-N-scf.in >  OUTPUT_ADS_GF_optxc-N-scf
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GF_optxc-N-pp-up.in >  OUTPUT_ADS_GF_optxc-N-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GF_optxc-N-pp-dn.in >  OUTPUT_ADS_GF_optxc-N-pp-dn
rm -r tmp_ads/

# SUBS
mpirun -np $NSLOTS pw.x -inp INPUT_SUBS_GF_optxc-N-scf.in >  OUTPUT_SUBS_GF_optxc-N-scf
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GF_optxc-N-pp-up.in >  OUTPUT_SUBS_GF_optxc-N-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GF_optxc-N-pp-dn.in >  OUTPUT_SUBS_GF_optxc-N-pp-dn
rm -r tmp_subs/
