#!/bin/bash

make_csh() {
	printf "#! /bin/bash -l
#
#SBATCH -J ${X}_${g}t${sl}-${i}
#SBATCH -p std.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# relax
mpirun -np \$SLURM_NTASKS pw.x -inp INPUT_G${X}_${g}t${sl}-${i}-relax.in > OUTPUT_G${X}_${g}t${sl}-${i}-relax

# delete tmp
rm -r tmp/" > relax.csh

	printf "#! /bin/bash -l
#
#SBATCH -J ${X}_${g}t${sl}-${i}
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np \$SLURM_NTASKS pw.x -inp INPUT_G${X}_${g}t${sl}-${i}-scf.in > OUTPUT_G${X}_${g}t${sl}-${i}-scf

# pp
mpirun -np \$SLURM_NTASKS pp.x -inp INPUT_G${X}_${g}t${sl}-${i}-pp-up.in > OUTPUT_G${X}_${g}t${sl}-${i}-pp-up
mpirun -np \$SLURM_NTASKS pp.x -inp INPUT_G${X}_${g}t${sl}-${i}-pp-dn.in > OUTPUT_G${X}_${g}t${sl}-${i}-pp-dn

# bader
mpirun -np \$SLURM_NTASKS pp.x -inp INPUT_G${X}_${g}t${sl}-${i}-bader.in > OUTPUT_G${X}_${g}t${sl}-${i}-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np \$SLURM_NTASKS pw.x -inp INPUT_G${X}_${g}t${sl}-${i}-nscf.in > OUTPUT_G${X}_${g}t${sl}-${i}-nscf

# pdos
mpirun -np \$SLURM_NTASKS projwfc.x -inp INPUT_G${X}_${g}t${sl}-${i}-pdos.in > OUTPUT_G${X}_${g}t${sl}-${i}-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np \$SLURM_NTASKS pw.x -inp INPUT_G${X}_${g}t${sl}-${i}-bands1.in > OUTPUT_G${X}_${g}t${sl}-${i}-bands1

# bands2
mpirun -np \$SLURM_NTASKS bands.x -inp INPUT_G${X}_${g}t${sl}-${i}-bands2-up.in > OUTPUT_G${X}_${g}t${sl}-${i}-bands2-up
mpirun -np \$SLURM_NTASKS bands.x -inp INPUT_G${X}_${g}t${sl}-${i}-bands2-dn.in > OUTPUT_G${X}_${g}t${sl}-${i}-bands2-dn

# delete tmp
rm -r tmp/" > etc.csh

	printf "#! /bin/bash -l
#
#SBATCH -J ${X}_${g}t${sl}-${i}
#SBATCH -p fast.q
#SBATCH --ntasks=24
#
#SBATCH --mail-user=deleted@deleted.edu
#SBATCH --mail-type=ALL
#SBATCH --export=ALL

hostname
module load quantum-espresso/6.1

# scf
mpirun -np \$SLURM_NTASKS pw.x -inp INPUT_ADS_G${X}_${g}t${sl}-${i}-scf.in > OUTPUT_ADS_G${X}_${g}t${sl}-${i}-scf
mpirun -np \$SLURM_NTASKS pw.x -inp INPUT_SUBS_G${X}_${g}t${sl}-${i}-scf.in > OUTPUT_SUBS_G${X}_${g}t${sl}-${i}-scf

# pp
mpirun -np \$SLURM_NTASKS pp.x -inp INPUT_ADS_G${X}_${g}t${sl}-${i}-pp.in > OUTPUT_ADS_G${X}_${g}t${sl}-${i}-pp
mpirun -np \$SLURM_NTASKS pp.x -inp INPUT_SUBS_G${X}_${g}t${sl}-${i}-pp.in > OUTPUT_SUBS_G${X}_${g}t${sl}-${i}-pp

# bader
mpirun -np \$SLURM_NTASKS pp.x -inp INPUT_ADS_G${X}_${g}t${sl}-${i}-bader.in > OUTPUT_ADS_G${X}_${g}t${sl}-${i}-bader
mpirun -np \$SLURM_NTASKS pp.x -inp INPUT_SUBS_G${X}_${g}t${sl}-${i}-bader.in > OUTPUT_SUBS_G${X}_${g}t${sl}-${i}-bader

rm -r tmp_ads/
rm -r tmp_subs/" > etc2.csh
}

# halogen
read -p 'Halogen [F/Cl/Br/I]: ' X

for g in 'ip' 'op'; do
	printf '=====G'${X}'_'${g}'=====\n'
	cd G${X}_${g}
	for s in 'C' 'LH' 'opp' 'vac' 'X' 'XC'; do
		case $s in
			'C' )
				sl='c' ;;
			'LH' )
				sl='lh' ;;
			'opp' )
				sl='o' ;;
			'vac' )
				sl='v' ;;
			'X' )
				sl='x' ;;
			'XC' )
				sl='xc' ;;
		esac

		cd top_${s}
		printf 'top_'${s}'\n\n'
		if [ $s == 'XC' ]; then
			for i in 'N' 'P' 'Z'; do
				cd $i
				make_csh
				cd ..
			done
		else
			for i in 'X' 'Y' 'Z'; do
				cd $i
				make_csh
				cd ..
			done
		fi
		cd ..
	done
	cd ..
done
