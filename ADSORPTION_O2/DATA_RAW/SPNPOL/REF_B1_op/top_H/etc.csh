#! /bin/bash -l
#
#SBATCH -J B1_opH-etc
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL


hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_B1_opH-scf.in > OUTPUT_B1_opH-scf
# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_B1_opH-pp-up.in > OUTPUT_B1_opH-pp-up
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_B1_opH-pp-dn.in > OUTPUT_B1_opH-pp-dn
# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_B1_opH-bader.in > OUTPUT_B1_opH-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_B1_opH-nscf.in > OUTPUT_B1_opH-nscf
# pdos
mpirun -np $SLURM_NTASKS projwfc.x -inp INPUT_B1_opH-pdos.in > OUTPUT_B1_opH-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_B1_opH-bands1.in > OUTPUT_B1_opH-bands1
# bands2
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_B1_opH-bands2-up.in > OUTPUT_B1_opH-bands2-up
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_B1_opH-bands2-dn.in > OUTPUT_B1_opH-bands2-dn

rm -r tmp/

