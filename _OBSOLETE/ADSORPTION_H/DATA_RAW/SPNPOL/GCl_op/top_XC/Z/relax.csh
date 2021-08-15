#! /bin/bash -l
#
#SBATCH -J Cl_optxc-Z
#SBATCH -p std.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GCl_optxc-Z-relax.in > OUTPUT_GCl_optxc-Z-relax

# delete tmp
rm -r tmp/