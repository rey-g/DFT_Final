#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GF_optx-Y
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np $NSLOTS pw.x -inp INPUT_ADS_GF_optx-Y-scf.in >  OUTPUT_ADS_GF_optx-Y-scf
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GF_optx-Y-pp-up.in >  OUTPUT_ADS_GF_optx-Y-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GF_optx-Y-pp-dn.in >  OUTPUT_ADS_GF_optx-Y-pp-dn
rm -r tmp_ads/

# SUBS
mpirun -np $NSLOTS pw.x -inp INPUT_SUBS_GF_optx-Y-scf.in >  OUTPUT_SUBS_GF_optx-Y-scf
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GF_optx-Y-pp-up.in >  OUTPUT_SUBS_GF_optx-Y-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GF_optx-Y-pp-dn.in >  OUTPUT_SUBS_GF_optx-Y-pp-dn
rm -r tmp_subs/
