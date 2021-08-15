#! /bin/bash -l
#
#SBATCH -J F_optxc-N
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GF_optxc-N-scf.in > OUTPUT_ADS_GF_optxc-N-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GF_optxc-N-scf.in > OUTPUT_SUBS_GF_optxc-N-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GF_optxc-N-pp.in > OUTPUT_ADS_GF_optxc-N-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GF_optxc-N-pp.in > OUTPUT_SUBS_GF_optxc-N-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GF_optxc-N-bader.in > OUTPUT_ADS_GF_optxc-N-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GF_optxc-N-bader.in > OUTPUT_SUBS_GF_optxc-N-bader

rm -r tmp_ads/
rm -r tmp_subs/