#!/bin/bash

gen_csh() {
	printf "#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N ${X}_${g}t${sl}
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np \$NSLOTS pw.x -inp INPUT_G${X}_${g}t${sl}-scf.in > OUTPUT_G${X}_${g}t${sl}-scf

# copy tmp folder
cp -r tmp/ nscf
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np \$NSLOTS pw.x -inp INPUT_G${X}_${g}t${sl}-nscf.in > OUTPUT_G${X}_${g}t${sl}-nscf

# pdos
mpirun -np \$NSLOTS projwfc.x -inp INPUT_G${X}_${g}t${sl}-pdos.in > OUTPUT_G${X}_${g}t${sl}-pdos

# delete tmp
rm -r tmp/" > etc2.csh
}

# halogen
read -p 'Halogen [F/Cl/Br/I]: ' X

for g in 'ip' 'op'; do
	mkdir -p G${X}_${g}
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

		mkdir -p top_${s}
		cd top_${s}
		printf 'top_'${s}'\n\n'
		gen_csh
		cd ..
	done
	cd ..
done
