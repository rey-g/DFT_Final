#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N I_iptlh-Z
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1
echo started at `date`

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GI_iptlh-Z-relax.in | tee OUTPUT_GI_iptlh-Z-relax
rm -r tmp/

echo finished at `date`
