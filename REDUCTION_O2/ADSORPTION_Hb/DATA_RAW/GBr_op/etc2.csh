#! /bin/bash -l
#
#SBATCH -J GBr_op
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GBr_op-scf.in > OUTPUT_ADS_GBr_op-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GBr_op-scf.in > OUTPUT_SUBS_GBr_op-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GBr_op-pp.in > OUTPUT_ADS_GBr_op-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GBr_op-pp.in > OUTPUT_SUBS_GBr_op-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GBr_op-bader.in > OUTPUT_ADS_GBr_op-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GBr_op-bader.in > OUTPUT_SUBS_GBr_op-bader

rm -r tmp_ads/
rm -r tmp_subs/