#! /bin/bash -l
#
#SBATCH -J I_optv-Z
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GI_optv-Z-scf.in > OUTPUT_GI_optv-Z-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GI_optv-Z-pp-up.in > OUTPUT_GI_optv-Z-pp-up
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GI_optv-Z-pp-dn.in > OUTPUT_GI_optv-Z-pp-dn

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GI_optv-Z-bader.in > OUTPUT_GI_optv-Z-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GI_optv-Z-nscf.in > OUTPUT_GI_optv-Z-nscf

# pdos
mpirun -np $SLURM_NTASKS projwfc.x -inp INPUT_GI_optv-Z-pdos.in > OUTPUT_GI_optv-Z-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GI_optv-Z-bands1.in > OUTPUT_GI_optv-Z-bands1

# bands2
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_GI_optv-Z-bands2-up.in > OUTPUT_GI_optv-Z-bands2-up
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_GI_optv-Z-bands2-dn.in > OUTPUT_GI_optv-Z-bands2-dn

# delete tmp
rm -r tmp/