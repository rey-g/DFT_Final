#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N Cl_iptx
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1
echo started at `date`

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_iptx-relax.in | tee OUTPUT_GCl_iptx-relax
rm -r tmp/

echo finished at `date`
