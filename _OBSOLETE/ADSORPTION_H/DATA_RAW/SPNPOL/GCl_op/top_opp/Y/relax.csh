#! /bin/bash -l
#
#SBATCH -J Cl_opto-Y
#SBATCH -p std.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# relax
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GCl_opto-Y-relax.in > OUTPUT_GCl_opto-Y-relax

# delete tmp
rm -r tmp/