#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GF_iptv-X
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np $NSLOTS pw.x -inp INPUT_ADS_GF_iptv-X-scf.in >  OUTPUT_ADS_GF_iptv-X-scf
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GF_iptv-X-pp-up.in >  OUTPUT_ADS_GF_iptv-X-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GF_iptv-X-pp-dn.in >  OUTPUT_ADS_GF_iptv-X-pp-dn
rm -r tmp_ads/

# SUBS
mpirun -np $NSLOTS pw.x -inp INPUT_SUBS_GF_iptv-X-scf.in >  OUTPUT_SUBS_GF_iptv-X-scf
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GF_iptv-X-pp-up.in >  OUTPUT_SUBS_GF_iptv-X-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GF_iptv-X-pp-dn.in >  OUTPUT_SUBS_GF_iptv-X-pp-dn
rm -r tmp_subs/
