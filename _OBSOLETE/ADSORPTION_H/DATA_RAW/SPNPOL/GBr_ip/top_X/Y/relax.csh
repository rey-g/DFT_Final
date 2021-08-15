#! /bin/bash -l
#
#SBATCH -J Br_iptx-Y
#SBATCH -p std.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GBr_iptx-Y-relax.in > OUTPUT_GBr_iptx-Y-relax

# delete tmp
rm -r tmp/