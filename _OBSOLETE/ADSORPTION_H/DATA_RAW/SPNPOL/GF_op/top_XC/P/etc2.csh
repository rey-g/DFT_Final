#! /bin/bash -l
#
#SBATCH -J F_optxc-P
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GF_optxc-P-scf.in > OUTPUT_ADS_GF_optxc-P-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GF_optxc-P-scf.in > OUTPUT_SUBS_GF_optxc-P-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GF_optxc-P-pp.in > OUTPUT_ADS_GF_optxc-P-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GF_optxc-P-pp.in > OUTPUT_SUBS_GF_optxc-P-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GF_optxc-P-bader.in > OUTPUT_ADS_GF_optxc-P-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GF_optxc-P-bader.in > OUTPUT_SUBS_GF_optxc-P-bader

rm -r tmp_ads/
rm -r tmp_subs/