#! /bin/bash -l
#
#SBATCH -J GI_op
#SBATCH -p std.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GI_op-relax.in > OUTPUT_GI_op-relax

# delete tmp
rm -r tmp/