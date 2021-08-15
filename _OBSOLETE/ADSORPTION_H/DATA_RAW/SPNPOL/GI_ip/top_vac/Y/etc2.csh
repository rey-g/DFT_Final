#! /bin/bash -l
#
#SBATCH -J I_iptv-Y
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GI_iptv-Y-scf.in > OUTPUT_ADS_GI_iptv-Y-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GI_iptv-Y-scf.in > OUTPUT_SUBS_GI_iptv-Y-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_iptv-Y-pp.in > OUTPUT_ADS_GI_iptv-Y-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_iptv-Y-pp.in > OUTPUT_SUBS_GI_iptv-Y-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_iptv-Y-bader.in > OUTPUT_ADS_GI_iptv-Y-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_iptv-Y-bader.in > OUTPUT_SUBS_GI_iptv-Y-bader

rm -r tmp_ads/
rm -r tmp_subs/