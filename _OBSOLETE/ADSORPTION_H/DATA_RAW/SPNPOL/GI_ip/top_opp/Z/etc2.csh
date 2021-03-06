#! /bin/bash -l
#
#SBATCH -J I_ipto-Z
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GI_ipto-Z-scf.in > OUTPUT_ADS_GI_ipto-Z-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GI_ipto-Z-scf.in > OUTPUT_SUBS_GI_ipto-Z-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_ipto-Z-pp.in > OUTPUT_ADS_GI_ipto-Z-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_ipto-Z-pp.in > OUTPUT_SUBS_GI_ipto-Z-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_ipto-Z-bader.in > OUTPUT_ADS_GI_ipto-Z-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_ipto-Z-bader.in > OUTPUT_SUBS_GI_ipto-Z-bader

rm -r tmp_ads/
rm -r tmp_subs/