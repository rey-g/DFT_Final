#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N I_iptx
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1
echo started at `date`

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GI_iptx-relax.in | tee OUTPUT_GI_iptx-relax
rm -r tmp/

echo finished at `date`
