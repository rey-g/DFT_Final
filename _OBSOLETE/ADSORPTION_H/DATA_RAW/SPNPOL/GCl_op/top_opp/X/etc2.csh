#! /bin/bash -l
#
#SBATCH -J Cl_opto-X
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_ADS_GCl_opto-X-scf.in > OUTPUT_ADS_GCl_opto-X-scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_SUBS_GCl_opto-X-scf.in > OUTPUT_SUBS_GCl_opto-X-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GCl_opto-X-pp.in > OUTPUT_ADS_GCl_opto-X-pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GCl_opto-X-pp.in > OUTPUT_SUBS_GCl_opto-X-pp

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_ADS_GCl_opto-X-bader.in > OUTPUT_ADS_GCl_opto-X-bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_SUBS_GCl_opto-X-bader.in > OUTPUT_SUBS_GCl_opto-X-bader

rm -r tmp_ads/
rm -r tmp_subs/