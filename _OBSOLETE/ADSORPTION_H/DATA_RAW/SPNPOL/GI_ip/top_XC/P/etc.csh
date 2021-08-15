#! /bin/bash -l
#
#SBATCH -J I_iptxc-P
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GI_iptxc-P-scf.in > OUTPUT_GI_iptxc-P-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GI_iptxc-P-pp-up.in > OUTPUT_GI_iptxc-P-pp-up
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GI_iptxc-P-pp-dn.in > OUTPUT_GI_iptxc-P-pp-dn

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GI_iptxc-P-bader.in > OUTPUT_GI_iptxc-P-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GI_iptxc-P-nscf.in > OUTPUT_GI_iptxc-P-nscf

# pdos
mpirun -np $SLURM_NTASKS projwfc.x -inp INPUT_GI_iptxc-P-pdos.in > OUTPUT_GI_iptxc-P-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GI_iptxc-P-bands1.in > OUTPUT_GI_iptxc-P-bands1

# bands2
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_GI_iptxc-P-bands2-up.in > OUTPUT_GI_iptxc-P-bands2-up
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_GI_iptxc-P-bands2-dn.in > OUTPUT_GI_iptxc-P-bands2-dn

# delete tmp
rm -r tmp/