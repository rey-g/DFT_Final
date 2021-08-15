#! /bin/bash -l
#
#SBATCH -J Cl_iptlh-X
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GCl_iptlh-X-scf.in > OUTPUT_GCl_iptlh-X-scf

# pp
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GCl_iptlh-X-pp-up.in > OUTPUT_GCl_iptlh-X-pp-up
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GCl_iptlh-X-pp-dn.in > OUTPUT_GCl_iptlh-X-pp-dn

# bader
mpirun -np $SLURM_NTASKS pp.x -inp INPUT_GCl_iptlh-X-bader.in > OUTPUT_GCl_iptlh-X-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GCl_iptlh-X-nscf.in > OUTPUT_GCl_iptlh-X-nscf

# pdos
mpirun -np $SLURM_NTASKS projwfc.x -inp INPUT_GCl_iptlh-X-pdos.in > OUTPUT_GCl_iptlh-X-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np $SLURM_NTASKS pw.x -inp INPUT_GCl_iptlh-X-bands1.in > OUTPUT_GCl_iptlh-X-bands1

# bands2
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_GCl_iptlh-X-bands2-up.in > OUTPUT_GCl_iptlh-X-bands2-up
mpirun -np $SLURM_NTASKS bands.x -inp INPUT_GCl_iptlh-X-bands2-dn.in > OUTPUT_GCl_iptlh-X-bands2-dn

# delete tmp
rm -r tmp/