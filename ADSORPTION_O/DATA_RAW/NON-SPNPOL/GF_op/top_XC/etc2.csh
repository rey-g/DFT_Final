#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N top_xc
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GF_optxc-scf_ads.in | tee OUTPUT_GF_optxc-scf_ads
mpirun -np $NSLOTS pw.x -inp INPUT_GF_optxc-scf_subs.in | tee OUTPUT_GF_optxc-scf_subs

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GF_optxc-pp_ads.in | tee OUTPUT_GF_optxc-pp_ads
mpirun -np $NSLOTS pp.x -inp INPUT_GF_optxc-pp_subs.in | tee OUTPUT_GF_optxc-pp_subs

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GF_optxc-bader_ads.in | tee OUTPUT_GF_optxc-bader_ads
mpirun -np $NSLOTS pp.x -inp INPUT_GF_optxc-bader_subs.in | tee OUTPUT_GF_optxc-bader_subs

rm -r tmp_ads/
rm -r tmp_subs/