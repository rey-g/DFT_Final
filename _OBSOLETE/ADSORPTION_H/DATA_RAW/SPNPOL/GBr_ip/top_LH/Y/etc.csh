#! /bin/bash -l
#
#SBATCH -J Br_iptlh-Y
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GBr_iptlh-Y-scf.in > OUTPUT_GBr_iptlh-Y-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GBr_iptlh-Y-pp-up.in > OUTPUT_GBr_iptlh-Y-pp-up
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GBr_iptlh-Y-pp-dn.in > OUTPUT_GBr_iptlh-Y-pp-dn

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GBr_iptlh-Y-bader.in > OUTPUT_GBr_iptlh-Y-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GBr_iptlh-Y-nscf.in > OUTPUT_GBr_iptlh-Y-nscf

# pdos
mpirun -np $SLURM_NTASKS projwfc.x -inp INPUT_GBr_iptlh-Y-pdos.in > OUTPUT_GBr_iptlh-Y-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GBr_iptlh-Y-bands1.in > OUTPUT_GBr_iptlh-Y-bands1

# bands2
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_GBr_iptlh-Y-bands2-up.in > OUTPUT_GBr_iptlh-Y-bands2-up
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_GBr_iptlh-Y-bands2-dn.in > OUTPUT_GBr_iptlh-Y-bands2-dn

# delete tmp
rm -r tmp/