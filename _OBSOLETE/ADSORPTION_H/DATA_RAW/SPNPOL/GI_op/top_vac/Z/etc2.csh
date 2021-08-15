#! /bin/bash -l
#
#SBATCH -J I_optv-Z
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GI_optv-Z-scf.in > OUTPUT_ADS_GI_optv-Z-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GI_optv-Z-scf.in > OUTPUT_SUBS_GI_optv-Z-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_optv-Z-pp.in > OUTPUT_ADS_GI_optv-Z-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_optv-Z-pp.in > OUTPUT_SUBS_GI_optv-Z-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_optv-Z-bader.in > OUTPUT_ADS_GI_optv-Z-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_optv-Z-bader.in > OUTPUT_SUBS_GI_optv-Z-bader

rm -r tmp_ads/
rm -r tmp_subs/