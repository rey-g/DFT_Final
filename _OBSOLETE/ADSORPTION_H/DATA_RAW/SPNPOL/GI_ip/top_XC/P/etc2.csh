#! /bin/bash -l
#
#SBATCH -J I_iptxc-P
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GI_iptxc-P-scf.in > OUTPUT_ADS_GI_iptxc-P-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GI_iptxc-P-scf.in > OUTPUT_SUBS_GI_iptxc-P-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_iptxc-P-pp.in > OUTPUT_ADS_GI_iptxc-P-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_iptxc-P-pp.in > OUTPUT_SUBS_GI_iptxc-P-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_iptxc-P-bader.in > OUTPUT_ADS_GI_iptxc-P-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_iptxc-P-bader.in > OUTPUT_SUBS_GI_iptxc-P-bader

rm -r tmp_ads/
rm -r tmp_subs/