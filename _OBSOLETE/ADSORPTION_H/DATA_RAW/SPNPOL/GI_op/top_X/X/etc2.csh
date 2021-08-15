#! /bin/bash -l
#
#SBATCH -J I_optx-X
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GI_optx-X-scf.in > OUTPUT_ADS_GI_optx-X-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GI_optx-X-scf.in > OUTPUT_SUBS_GI_optx-X-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_optx-X-pp.in > OUTPUT_ADS_GI_optx-X-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_optx-X-pp.in > OUTPUT_SUBS_GI_optx-X-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_optx-X-bader.in > OUTPUT_ADS_GI_optx-X-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_optx-X-bader.in > OUTPUT_SUBS_GI_optx-X-bader

rm -r tmp_ads/
rm -r tmp_subs/