#! /bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N Cl_optxc-P
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1
echo started at `date`

# relax
mpirun -np $NSLOTS pw.x -inp INPUT_GCl_optxc-P-relax2.in | tee OUTPUT_GCl_optxc-P-relax2
rm -r tmp/

echo finished at `date`
