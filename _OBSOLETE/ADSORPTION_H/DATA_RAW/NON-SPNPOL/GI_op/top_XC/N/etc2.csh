#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N I_optxc-N
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GI_optxc-N-scf_ads.in | tee OUTPUT_GI_optxc-N-scf_ads
mpirun -np $NSLOTS pw.x -inp INPUT_GI_optxc-N-scf_subs.in | tee OUTPUT_GI_optxc-N-scf_subs

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GI_optxc-N-pp_ads.in | tee OUTPUT_GI_optxc-N-pp_ads
mpirun -np $NSLOTS pp.x -inp INPUT_GI_optxc-N-pp_subs.in | tee OUTPUT_GI_optxc-N-pp_subs

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GI_optxc-N-bader_ads.in | tee OUTPUT_GI_optxc-N-bader_ads
mpirun -np $NSLOTS pp.x -inp INPUT_GI_optxc-N-bader_subs.in | tee OUTPUT_GI_optxc-N-bader_subs

rm -r tmp_ads/
rm -r tmp_subs/