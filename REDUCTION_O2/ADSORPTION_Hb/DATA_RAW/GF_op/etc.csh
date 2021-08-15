#! /bin/bash -l
#
#SBATCH -J GF_op
#SBATCH -p std.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GF_op-scf.in > OUTPUT_GF_op-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GF_op-pp-up.in > OUTPUT_GF_op-pp-up
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GF_op-pp-dn.in > OUTPUT_GF_op-pp-dn

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GF_op-bader.in > OUTPUT_GF_op-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GF_op-nscf.in > OUTPUT_GF_op-nscf

# pdos
mpirun -np $SLURM_NTASKS projwfc.x -inp INPUT_GF_op-pdos.in > OUTPUT_GF_op-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GF_op-bands1.in > OUTPUT_GF_op-bands1

# bands2
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_GF_op-bands2-up.in > OUTPUT_GF_op-bands2-up
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_GF_op-bands2-dn.in > OUTPUT_GF_op-bands2-dn

# delete tmp
rm -r tmp/