#! /bin/bash -l
#
#SBATCH -J F_iptv-X
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GF_iptv-X-scf.in > OUTPUT_GF_iptv-X-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GF_iptv-X-pp-up.in > OUTPUT_GF_iptv-X-pp-up
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GF_iptv-X-pp-dn.in > OUTPUT_GF_iptv-X-pp-dn

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GF_iptv-X-bader.in > OUTPUT_GF_iptv-X-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GF_iptv-X-nscf.in > OUTPUT_GF_iptv-X-nscf

# pdos
mpirun -np $SLURM_NTASKS projwfc.x -inp INPUT_GF_iptv-X-pdos.in > OUTPUT_GF_iptv-X-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GF_iptv-X-bands1.in > OUTPUT_GF_iptv-X-bands1

# bands2
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_GF_iptv-X-bands2-up.in > OUTPUT_GF_iptv-X-bands2-up
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_GF_iptv-X-bands2-dn.in > OUTPUT_GF_iptv-X-bands2-dn

# delete tmp
rm -r tmp/