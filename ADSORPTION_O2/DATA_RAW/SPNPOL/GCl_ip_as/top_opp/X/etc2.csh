#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N GCl_ipto-X
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# ADS
mpirun -np $NSLOTS pw.x -inp INPUT_ADS_GCl_ipto-X-scf.in >  OUTPUT_ADS_GCl_ipto-X-scf
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GCl_ipto-X-pp-up.in >  OUTPUT_ADS_GCl_ipto-X-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_ADS_GCl_ipto-X-pp-dn.in >  OUTPUT_ADS_GCl_ipto-X-pp-dn
rm -r tmp_ads/

# SUBS
mpirun -np $NSLOTS pw.x -inp INPUT_SUBS_GCl_ipto-X-scf.in >  OUTPUT_SUBS_GCl_ipto-X-scf
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GCl_ipto-X-pp-up.in >  OUTPUT_SUBS_GCl_ipto-X-pp-up
mpirun -np $NSLOTS pp.x -inp INPUT_SUBS_GCl_ipto-X-pp-dn.in >  OUTPUT_SUBS_GCl_ipto-X-pp-dn
rm -r tmp_subs/
