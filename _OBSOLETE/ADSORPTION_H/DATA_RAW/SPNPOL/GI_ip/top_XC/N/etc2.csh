#! /bin/bash -l
#
#SBATCH -J I_iptxc-N
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GI_iptxc-N-scf.in > OUTPUT_ADS_GI_iptxc-N-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GI_iptxc-N-scf.in > OUTPUT_SUBS_GI_iptxc-N-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_iptxc-N-pp.in > OUTPUT_ADS_GI_iptxc-N-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_iptxc-N-pp.in > OUTPUT_SUBS_GI_iptxc-N-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_iptxc-N-bader.in > OUTPUT_ADS_GI_iptxc-N-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_iptxc-N-bader.in > OUTPUT_SUBS_GI_iptxc-N-bader

rm -r tmp_ads/
rm -r tmp_subs/