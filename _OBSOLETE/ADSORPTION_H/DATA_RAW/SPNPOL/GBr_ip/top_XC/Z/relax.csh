#! /bin/bash -l
#
#SBATCH -J Br_iptxc-Z
#SBATCH -p std.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GBr_iptxc-Z-relax.in > OUTPUT_GBr_iptxc-Z-relax

# delete tmp
rm -r tmp/