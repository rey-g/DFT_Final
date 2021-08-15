#! /bin/bash -l
#
#SBATCH -J F_optc-Z
#SBATCH -p std.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GF_optc-Z-relax.in > OUTPUT_GF_optc-Z-relax

# delete tmp
rm -r tmp/