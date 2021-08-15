#! /bin/bash -l
#
#SBATCH -J Br_opto-Z
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GBr_opto-Z-scf.in > OUTPUT_ADS_GBr_opto-Z-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GBr_opto-Z-scf.in > OUTPUT_SUBS_GBr_opto-Z-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GBr_opto-Z-pp.in > OUTPUT_ADS_GBr_opto-Z-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GBr_opto-Z-pp.in > OUTPUT_SUBS_GBr_opto-Z-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GBr_opto-Z-bader.in > OUTPUT_ADS_GBr_opto-Z-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GBr_opto-Z-bader.in > OUTPUT_SUBS_GBr_opto-Z-bader

rm -r tmp_ads/
rm -r tmp_subs/