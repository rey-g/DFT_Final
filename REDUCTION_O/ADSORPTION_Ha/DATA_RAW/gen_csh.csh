#!/bin/bash

make_csh() {
	printf "#! /bin/bash -l
#
#SBATCH -J G${X}_${g}
#SBATCH -p std.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# relax
mpirun -np \$SLURM_NTASKS pw.x -inp INPUT_G${X}_${g}-relax.in > OUTPUT_G${X}_${g}-relax

# delete tmp
rm -r tmp/" > relax.csh

	printf "#! /bin/bash -l
#
#SBATCH -J G${X}_${g}
#SBATCH -p std.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np \$SLURM_NTASKS pw.x -inp INPUT_G${X}_${g}-scf.in > OUTPUT_G${X}_${g}-scf

# pp
mpirun -np \$SLURM_NTASKS pp.x -inp INPUT_G${X}_${g}-pp-up.in > OUTPUT_G${X}_${g}-pp-up
mpirun -np \$SLURM_NTASKS pp.x -inp INPUT_G${X}_${g}-pp-dn.in > OUTPUT_G${X}_${g}-pp-dn

# bader
mpirun -np \$SLURM_NTASKS pp.x -inp INPUT_G${X}_${g}-bader.in > OUTPUT_G${X}_${g}-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np \$SLURM_NTASKS pw.x -inp INPUT_G${X}_${g}-nscf.in > OUTPUT_G${X}_${g}-nscf

# pdos
mpirun -np \$SLURM_NTASKS projwfc.x -inp INPUT_G${X}_${g}-pdos.in > OUTPUT_G${X}_${g}-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np \$SLURM_NTASKS pw.x -inp INPUT_G${X}_${g}-bands1.in > OUTPUT_G${X}_${g}-bands1

# bands2
mpirun -np \$SLURM_NTASKS bands.x -inp INPUT_G${X}_${g}-bands2-up.in > OUTPUT_G${X}_${g}-bands2-up
mpirun -np \$SLURM_NTASKS bands.x -inp INPUT_G${X}_${g}-bands2-dn.in > OUTPUT_G${X}_${g}-bands2-dn

# delete tmp
rm -r tmp/" > etc.csh

	printf "#! /bin/bash -l
#
#SBATCH -J G${X}_${g}
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np \$SLURM_NTASKS pw.x -inp INPUT_ADS_G${X}_${g}-scf.in > OUTPUT_ADS_G${X}_${g}-scf
mpirun -np \$SLURM_NTASKS pw.x -inp INPUT_SUBS_G${X}_${g}-scf.in > OUTPUT_SUBS_G${X}_${g}-scf

# pp
mpirun -np \$SLURM_NTASKS pp.x -inp INPUT_ADS_G${X}_${g}-pp.in > OUTPUT_ADS_G${X}_${g}-pp
mpirun -np \$SLURM_NTASKS pp.x -inp INPUT_SUBS_G${X}_${g}-pp.in > OUTPUT_SUBS_G${X}_${g}-pp

# bader
mpirun -np \$SLURM_NTASKS pp.x -inp INPUT_ADS_G${X}_${g}-bader.in > OUTPUT_ADS_G${X}_${g}-bader
mpirun -np \$SLURM_NTASKS pp.x -inp INPUT_SUBS_G${X}_${g}-bader.in > OUTPUT_SUBS_G${X}_${g}-bader

rm -r tmp_ads/
rm -r tmp_subs/" > etc2.csh
}

# halogen
for X in 'F' 'Cl' 'Br' 'I'; do
	for g in 'ip' 'op'; do
		cd G${X}_${g}
		make_csh
		cd ..
	done
done
