#! /bin/bash -l
#
#SBATCH -J B1_opV-etc
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL


hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_B1_opV-scf.in > OUTPUT_B1_opV-scf
# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_B1_opV-pp-up.in > OUTPUT_B1_opV-pp-up
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_B1_opV-pp-dn.in > OUTPUT_B1_opV-pp-dn
# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_B1_opV-bader.in > OUTPUT_B1_opV-bader

cp -r tmp/ -t nscf/
cp -r tmp/ -t bands/
rm -r tmp/

cd nscf/

# nscf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_B1_opV-nscf.in > OUTPUT_B1_opV-nscf
# pdos
mpirun -np $SLURM_NTASKS projwfc.x -inp INPUT_B1_opV-pdos.in > OUTPUT_B1_opV-pdos

rm -r tmp/
cd ../bands

# bands1
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_B1_opV-bands1.in > OUTPUT_B1_opV-bands1
# bands2
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_B1_opV-bands2-up.in > OUTPUT_B1_opV-bands2-up
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_B1_opV-bands2-dn.in > OUTPUT_B1_opV-bands2-dn

rm -r tmp/

