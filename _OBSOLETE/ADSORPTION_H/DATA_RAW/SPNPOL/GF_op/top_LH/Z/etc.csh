#! /bin/bash -l
#
#SBATCH -J F_optlh-Z
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GF_optlh-Z-scf.in > OUTPUT_GF_optlh-Z-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GF_optlh-Z-pp-up.in > OUTPUT_GF_optlh-Z-pp-up
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GF_optlh-Z-pp-dn.in > OUTPUT_GF_optlh-Z-pp-dn

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GF_optlh-Z-bader.in > OUTPUT_GF_optlh-Z-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GF_optlh-Z-nscf.in > OUTPUT_GF_optlh-Z-nscf

# pdos
mpirun -np $SLURM_NTASKS projwfc.x -inp INPUT_GF_optlh-Z-pdos.in > OUTPUT_GF_optlh-Z-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GF_optlh-Z-bands1.in > OUTPUT_GF_optlh-Z-bands1

# bands2
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_GF_optlh-Z-bands2-up.in > OUTPUT_GF_optlh-Z-bands2-up
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_GF_optlh-Z-bands2-dn.in > OUTPUT_GF_optlh-Z-bands2-dn

# delete tmp
rm -r tmp/