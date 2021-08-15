#! /bin/bash -l
#
#SBATCH -J F_iptc-X
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GF_iptc-X-scf.in > OUTPUT_ADS_GF_iptc-X-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GF_iptc-X-scf.in > OUTPUT_SUBS_GF_iptc-X-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GF_iptc-X-pp.in > OUTPUT_ADS_GF_iptc-X-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GF_iptc-X-pp.in > OUTPUT_SUBS_GF_iptc-X-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GF_iptc-X-bader.in > OUTPUT_ADS_GF_iptc-X-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GF_iptc-X-bader.in > OUTPUT_SUBS_GF_iptc-X-bader

rm -r tmp_ads/
rm -r tmp_subs/