#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N top_v
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GF_iptv-scf_ads.in | tee OUTPUT_GF_iptv-scf_ads
mpirun -np $NSLOTS pw.x -inp INPUT_GF_iptv-scf_subs.in | tee OUTPUT_GF_iptv-scf_subs

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GF_iptv-pp_ads.in | tee OUTPUT_GF_iptv-pp_ads
mpirun -np $NSLOTS pp.x -inp INPUT_GF_iptv-pp_subs.in | tee OUTPUT_GF_iptv-pp_subs

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GF_iptv-bader_ads.in | tee OUTPUT_GF_iptv-bader_ads
mpirun -np $NSLOTS pp.x -inp INPUT_GF_iptv-bader_subs.in | tee OUTPUT_GF_iptv-bader_subs

rm -r tmp_ads/
rm -r tmp_subs/