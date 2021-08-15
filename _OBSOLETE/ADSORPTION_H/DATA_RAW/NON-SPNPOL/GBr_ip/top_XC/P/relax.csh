#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N Br_iptxc-P
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1
echo started at `date`

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GBr_iptxc-P-relax.in | tee OUTPUT_GBr_iptxc-P-relax
rm -r tmp/

echo finished at `date`