#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N Br_iptc-X
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $NSLOTS pw.x -inp INPUT_ADS_GBr_iptc-X-scf.in > OUTPUT_ADS_GBr_iptc-X-scf
mpirun -np $NSLOTS pw.x -inp INPUT_SUBS_GBr_iptc-X-scf.in > OUTPUT_SUBS_GBr_iptc-X-scf

# pp
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GBr_iptc-X-pp.in > OUTPUT_ADS_GBr_iptc-X-pp
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GBr_iptc-X-pp.in > OUTPUT_SUBS_GBr_iptc-X-pp

# bader
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GBr_iptc-X-bader.in > OUTPUT_ADS_GBr_iptc-X-bader
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GBr_iptc-X-bader.in > OUTPUT_SUBS_GBr_iptc-X-bader

rm -r tmp_ads/
rm -r tmp_subs/