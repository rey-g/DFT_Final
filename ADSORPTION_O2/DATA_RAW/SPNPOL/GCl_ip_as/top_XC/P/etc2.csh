#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GCl_iptxc-P
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np $NSLOTS pw.x -inp INPUT_ADS_GCl_iptxc-P-scf.in >  OUTPUT_ADS_GCl_iptxc-P-scf
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GCl_iptxc-P-pp-up.in >  OUTPUT_ADS_GCl_iptxc-P-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GCl_iptxc-P-pp-dn.in >  OUTPUT_ADS_GCl_iptxc-P-pp-dn
rm -r tmp_ads/

# SUBS
mpirun -np $NSLOTS pw.x -inp INPUT_SUBS_GCl_iptxc-P-scf.in >  OUTPUT_SUBS_GCl_iptxc-P-scf
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GCl_iptxc-P-pp-up.in >  OUTPUT_SUBS_GCl_iptxc-P-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GCl_iptxc-P-pp-dn.in >  OUTPUT_SUBS_GCl_iptxc-P-pp-dn
rm -r tmp_subs/
