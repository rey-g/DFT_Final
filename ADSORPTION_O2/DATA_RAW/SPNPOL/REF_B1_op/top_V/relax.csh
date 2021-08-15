#! /bin/bash -l
#
#SBATCH -J B1_opV-relax
#SBATCH -p std.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL


hostname
module load quantum-espresso/6.1

mpirun -np $SLURM_NTASKS pw.x -inp INPUT_B1_opV-relax.in > OUTPUT_B1_opV-relax

rm -r tmp/

