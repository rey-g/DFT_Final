#! /bin/bash -l
#
#SBATCH -J Cl_iptlh-Y
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GCl_iptlh-Y-scf.in > OUTPUT_ADS_GCl_iptlh-Y-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GCl_iptlh-Y-scf.in > OUTPUT_SUBS_GCl_iptlh-Y-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GCl_iptlh-Y-pp.in > OUTPUT_ADS_GCl_iptlh-Y-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GCl_iptlh-Y-pp.in > OUTPUT_SUBS_GCl_iptlh-Y-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GCl_iptlh-Y-bader.in > OUTPUT_ADS_GCl_iptlh-Y-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GCl_iptlh-Y-bader.in > OUTPUT_SUBS_GCl_iptlh-Y-bader

rm -r tmp_ads/
rm -r tmp_subs/