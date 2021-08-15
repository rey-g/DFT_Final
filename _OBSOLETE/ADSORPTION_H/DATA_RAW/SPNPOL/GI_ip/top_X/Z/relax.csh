#! /bin/bash -l
#
#SBATCH -J I_iptx-Z
#SBATCH -p std.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GI_iptx-Z-relax.in > OUTPUT_GI_iptx-Z-relax

# delete tmp
rm -r tmp/