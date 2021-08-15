#! /bin/bash -l
#
#SBATCH -J GI_ip
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GI_ip-scf.in > OUTPUT_ADS_GI_ip-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GI_ip-scf.in > OUTPUT_SUBS_GI_ip-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_ip-pp.in > OUTPUT_ADS_GI_ip-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_ip-pp.in > OUTPUT_SUBS_GI_ip-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GI_ip-bader.in > OUTPUT_ADS_GI_ip-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GI_ip-bader.in > OUTPUT_SUBS_GI_ip-bader

rm -r tmp_ads/
rm -r tmp_subs/