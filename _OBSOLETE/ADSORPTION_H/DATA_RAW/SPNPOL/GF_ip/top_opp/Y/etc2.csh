#! /bin/bash -l
#
#SBATCH -J F_ipto-Y
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GF_ipto-Y-scf.in > OUTPUT_ADS_GF_ipto-Y-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GF_ipto-Y-scf.in > OUTPUT_SUBS_GF_ipto-Y-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GF_ipto-Y-pp.in > OUTPUT_ADS_GF_ipto-Y-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GF_ipto-Y-pp.in > OUTPUT_SUBS_GF_ipto-Y-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GF_ipto-Y-bader.in > OUTPUT_ADS_GF_ipto-Y-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GF_ipto-Y-bader.in > OUTPUT_SUBS_GF_ipto-Y-bader

rm -r tmp_ads/
rm -r tmp_subs/