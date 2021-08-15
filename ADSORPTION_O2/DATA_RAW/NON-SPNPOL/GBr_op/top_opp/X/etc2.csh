#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N Br_opto-X
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_opto-X-scf_ads.in | tee OUTPUT_GBr_opto-X-scf_ads
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_opto-X-scf_subs.in | tee OUTPUT_GBr_opto-X-scf_subs

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_opto-X-pp_ads.in | tee OUTPUT_GBr_opto-X-pp_ads
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_opto-X-pp_subs.in | tee OUTPUT_GBr_opto-X-pp_subs

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_opto-X-bader_ads.in | tee OUTPUT_GBr_opto-X-bader_ads
mpirun -np $NSLOTS pp.x -inp INPUT_GBr_opto-X-bader_subs.in | tee OUTPUT_GBr_opto-X-bader_subs

rm -r tmp_ads/
rm -r tmp_subs/