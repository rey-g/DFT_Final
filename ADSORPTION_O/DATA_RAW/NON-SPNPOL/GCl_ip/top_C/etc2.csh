#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N top_c
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_iptc-scf_ads.in | tee OUTPUT_GCl_iptc-scf_ads
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_iptc-scf_subs.in | tee OUTPUT_GCl_iptc-scf_subs

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GCl_iptc-pp_ads.in | tee OUTPUT_GCl_iptc-pp_ads
mpirun -np $NSLOTS pp.x -inp INPUT_GCl_iptc-pp_subs.in | tee OUTPUT_GCl_iptc-pp_subs

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GCl_iptc-bader_ads.in | tee OUTPUT_GCl_iptc-bader_ads
mpirun -np $NSLOTS pp.x -inp INPUT_GCl_iptc-bader_subs.in | tee OUTPUT_GCl_iptc-bader_subs

rm -r tmp_ads/
rm -r tmp_subs/