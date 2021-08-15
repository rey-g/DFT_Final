#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N Br_optxc-P
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_optxc-P-scf_ads.in | tee OUTPUT_GBr_optxc-P-scf_ads
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_optxc-P-scf_subs.in | tee OUTPUT_GBr_optxc-P-scf_subs

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_optxc-P-pp_ads.in | tee OUTPUT_GBr_optxc-P-pp_ads
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_optxc-P-pp_subs.in | tee OUTPUT_GBr_optxc-P-pp_subs

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_optxc-P-bader_ads.in | tee OUTPUT_GBr_optxc-P-bader_ads
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_optxc-P-bader_subs.in | tee OUTPUT_GBr_optxc-P-bader_subs

rm -r tmp_ads/
rm -r tmp_subs/