#! /bin/bash -l
#
#SBATCH -J I_iptx-X
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GI_iptx-X-scf.in > OUTPUT_ADS_GI_iptx-X-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GI_iptx-X-scf.in > OUTPUT_SUBS_GI_iptx-X-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_iptx-X-pp.in > OUTPUT_ADS_GI_iptx-X-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_iptx-X-pp.in > OUTPUT_SUBS_GI_iptx-X-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_iptx-X-bader.in > OUTPUT_ADS_GI_iptx-X-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_iptx-X-bader.in > OUTPUT_SUBS_GI_iptx-X-bader

rm -r tmp_ads/
rm -r tmp_subs/