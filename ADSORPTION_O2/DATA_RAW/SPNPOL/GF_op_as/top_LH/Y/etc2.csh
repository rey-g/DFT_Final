#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GF_optlh-Y
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np $NSLOTS pw.x -inp INPUT_ADS_GF_optlh-Y-scf.in >  OUTPUT_ADS_GF_optlh-Y-scf
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GF_optlh-Y-pp-up.in >  OUTPUT_ADS_GF_optlh-Y-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GF_optlh-Y-pp-dn.in >  OUTPUT_ADS_GF_optlh-Y-pp-dn
rm -r tmp_ads/

# SUBS
mpirun -np $NSLOTS pw.x -inp INPUT_SUBS_GF_optlh-Y-scf.in >  OUTPUT_SUBS_GF_optlh-Y-scf
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GF_optlh-Y-pp-up.in >  OUTPUT_SUBS_GF_optlh-Y-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GF_optlh-Y-pp-dn.in >  OUTPUT_SUBS_GF_optlh-Y-pp-dn
rm -r tmp_subs/
