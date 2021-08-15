#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N F_iptlh-Y
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1
echo started at `date`

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GF_iptlh-Y-relax.in | tee OUTPUT_GF_iptlh-Y-relax
rm -r tmp/

echo finished at `date`
