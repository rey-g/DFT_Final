#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N I_iptxc-N
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1
echo started at `date`

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GI_iptxc-N-relax.in | tee OUTPUT_GI_iptxc-N-relax
rm -r tmp/

echo finished at `date`
