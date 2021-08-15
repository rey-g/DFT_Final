#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -N top_o
#$ -q fast.q
#$ -V
#$ -M deleted@deleted.edu
#$ -m e

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_GI_ipto-scf_ads.in | tee OUTPUT_GI_ipto-scf_ads
mpirun -np $NSLOTS pw.x -inp INPUT_GI_ipto-scf_subs.in | tee OUTPUT_GI_ipto-scf_subs

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_GI_ipto-pp_ads.in | tee OUTPUT_GI_ipto-pp_ads
mpirun -np $NSLOTS pp.x -inp INPUT_GI_ipto-pp_subs.in | tee OUTPUT_GI_ipto-pp_subs

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_GI_ipto-bader_ads.in | tee OUTPUT_GI_ipto-bader_ads
mpirun -np $NSLOTS pp.x -inp INPUT_GI_ipto-bader_subs.in | tee OUTPUT_GI_ipto-bader_subs

rm -r tmp_ads/
rm -r tmp_subs/