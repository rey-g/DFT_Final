#! /bin/bash -l
#
#SBATCH -J F_iptlh-X
#SBATCH -p std.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GF_iptlh-X-relax.in > OUTPUT_GF_iptlh-X-relax

# delete tmp
rm -r tmp/