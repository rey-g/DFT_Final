#!/bin/bash

gen_csh() {
	printf "#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q std.q
#$ -N ${X}_${g}t${sl}-${i}
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# relax
mpirun -np \$NSLOTS pw.x -inp INPUT_G${X}_${g}t${sl}-${i}-relax.in > OUTPUT_G${X}_${g}t${sl}-${i}-relax

# delete tmp
rm -r tmp/" > relax.csh

	printf "#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N ${X}_${g}t${sl}-${i}
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np \$NSLOTS pw.x -inp INPUT_G${X}_${g}t${sl}-${i}-scf.in > OUTPUT_G${X}_${g}t${sl}-${i}-scf

# pp
mpirun -np \$NSLOTS pp.x -inp INPUT_G${X}_${g}t${sl}-${i}-pp-up.in > OUTPUT_G${X}_${g}t${sl}-${i}-pp-up
mpirun -np \$NSLOTS pp.x -inp INPUT_G${X}_${g}t${sl}-${i}-pp-dn.in > OUTPUT_G${X}_${g}t${sl}-${i}-pp-dn

# bader
mpirun -np \$NSLOTS pp.x -inp INPUT_G${X}_${g}t${sl}-${i}-bader.in > OUTPUT_G${X}_${g}t${sl}-${i}-bader

# copy tmp folder
cp -r tmp/ nscf
cp -r tmp/ bands
rm -r tmp/

# chdir to nscf dir
cd nscf/

# nscf
mpirun -np \$NSLOTS pw.x -inp INPUT_G${X}_${g}t${sl}-${i}-nscf.in > OUTPUT_G${X}_${g}t${sl}-${i}-nscf

# pdos
mpirun -np \$NSLOTS projwfc.x -inp INPUT_G${X}_${g}t${sl}-${i}-pdos.in > OUTPUT_G${X}_${g}t${sl}-${i}-pdos

# delete tmp
rm -r tmp/

# chdir to bands dir
cd ../bands/

# bands1
mpirun -np \$NSLOTS pw.x -inp INPUT_G${X}_${g}t${sl}-${i}-bands1.in > OUTPUT_G${X}_${g}t${sl}-${i}-bands1

# bands2
mpirun -np \$NSLOTS bands.x -inp INPUT_G${X}_${g}t${sl}-${i}-bands2-up.in > OUTPUT_G${X}_${g}t${sl}-${i}-bands2-up
mpirun -np \$NSLOTS bands.x -inp INPUT_G${X}_${g}t${sl}-${i}-bands2-dn.in > OUTPUT_G${X}_${g}t${sl}-${i}-bands2-dn

# delete tmp
rm -r tmp/" > etc.csh

	printf "#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q fast.q
#$ -N ${X}_${g}t${sl}-${i}
#$ -M deleted@deleted.edu
#$ -m e
#$ -V

hostname
module load quantum-espresso/6.1

# scf
mpirun -np \$NSLOTS pw.x -inp INPUT_ADS_G${X}_${g}t${sl}-${i}-scf.in > OUTPUT_ADS_G${X}_${g}t${sl}-${i}-scf
mpirun -np \$NSLOTS pw.x -inp INPUT_SUBS_G${X}_${g}t${sl}-${i}-scf.in > OUTPUT_SUBS_G${X}_${g}t${sl}-${i}-scf

# pp
mpirun -np \$NSLOTS pp.x -inp INPUT_ADS_G${X}_${g}t${sl}-${i}-pp.in > OUTPUT_ADS_G${X}_${g}t${sl}-${i}-pp
mpirun -np \$NSLOTS pp.x -inp INPUT_SUBS_G${X}_${g}t${sl}-${i}-pp.in > OUTPUT_SUBS_G${X}_${g}t${sl}-${i}-pp

# bader
mpirun -np \$NSLOTS pp.x -inp INPUT_ADS_G${X}_${g}t${sl}-${i}-bader.in > OUTPUT_ADS_G${X}_${g}t${sl}-${i}-bader
mpirun -np \$NSLOTS pp.x -inp INPUT_SUBS_G${X}_${g}t${sl}-${i}-bader.in > OUTPUT_SUBS_G${X}_${g}t${sl}-${i}-bader

rm -r tmp_ads/
rm -r tmp_subs/" > etc2.csh
}

modify_lines() {
	# pw input files
	sed -i '23i \ \ \ \ nspin = 2 ,\n\ \ \ \ starting_magnetization(1) = 0.5,\n\ \ \ \ starting_magnetization(2) = 0.5,\n\ \ \ \ starting_magnetization(3) = 0.5,' *relax.in
	sed -i '23i \ \ \ \ nspin = 2 ,\n\ \ \ \ starting_magnetization(1) = 0.5,\n\ \ \ \ starting_magnetization(2) = 0.5,\n\ \ \ \ starting_magnetization(3) = 0.5,' *scf.in
	sed -i -e '39,71d' *scf.in
	cd nscf
		sed -i '23i \ \ \ \ nspin = 2 ,\n\ \ \ \ starting_magnetization(1) = 0.5,\n\ \ \ \ starting_magnetization(2) = 0.5,\n\ \ \ \ starting_magnetization(3) = 0.5,' *nscf.in
		sed -i -e '39,71d' *nscf.in
	cd ../bands
		sed -i '23i \ \ \ \ nspin = 2 ,\n\ \ \ \ starting_magnetization(1) = 0.5,\n\ \ \ \ starting_magnetization(2) = 0.5,\n\ \ \ \ starting_magnetization(3) = 0.5,' *bands1.in
	    sed -i -e '39,71d' *bands1.in
	cd ..
	
	# pp input files
	sed -i 's/_chg/_chg-up/' *pp-up.in
	sed -i 's/spin_component = 0/spin_component = 1/' *pp-up.in
	sed -i 's/_chg/_chg-dn/' *pp-dn.in
	sed -i 's/spin_component = 0/spin_component = 2/' *pp-dn.in
	
	cd bands
	# bands input files
	sed -i 's/_bands/_bands-up/' *bands2-up.in
	sed -i '6i \ \ \ \ spin_component = 1 ,\n\ \ \ \ no_overlap = .true. ,' *bands2-up.in
	sed -i 's/_bands/_bands-dn/' *bands2-dn.in
	sed -i '6i \ \ \ \ spin_component = 2 ,\n\ \ \ \ no_overlap = .true. ,' *bands2-dn.in
	cd ..
}

copy_files() {
	# copy files
	cp -t ./ ../../../../NON-SPNPOL/G${X}_${g}/top_${s}/${i}/*.in
	rm INPUT_*relax[0-9].in
	cp -t ./nscf ../../../../NON-SPNPOL/G${X}_${g}/top_${s}/${i}/nscf/*.in
	cp -t ./bands ../../../../NON-SPNPOL/G${X}_${g}/top_${s}/${i}/bands/*.in
}

dupl_spnpol() {
	# rename _ads and _subs
	mv INPUT_G${X}_${g}t${sl}-${i}-scf_ads.in INPUT_ADS_G${X}_${g}t${sl}-${i}-scf.in
	mv INPUT_G${X}_${g}t${sl}-${i}-pp_ads.in INPUT_ADS_G${X}_${g}t${sl}-${i}-pp.in
	mv INPUT_G${X}_${g}t${sl}-${i}-bader_ads.in INPUT_ADS_G${X}_${g}t${sl}-${i}-bader.in
	mv INPUT_G${X}_${g}t${sl}-${i}-scf_subs.in INPUT_SUBS_G${X}_${g}t${sl}-${i}-scf.in
	mv INPUT_G${X}_${g}t${sl}-${i}-pp_subs.in INPUT_SUBS_G${X}_${g}t${sl}-${i}-pp.in
	mv INPUT_G${X}_${g}t${sl}-${i}-bader_subs.in INPUT_SUBS_G${X}_${g}t${sl}-${i}-bader.in
	
	# create dn and up
	cp INPUT_G${X}_${g}t${sl}-${i}-pp.in INPUT_G${X}_${g}t${sl}-${i}-pp-up.in
	cp INPUT_G${X}_${g}t${sl}-${i}-pp-up.in INPUT_G${X}_${g}t${sl}-${i}-pp-dn.in
	cd bands
		mv INPUT_G${X}_${g}t${sl}-${i}-bands2.in INPUT_G${X}_${g}t${sl}-${i}-bands2-up.in
		cp INPUT_G${X}_${g}t${sl}-${i}-bands2-up.in INPUT_G${X}_${g}t${sl}-${i}-bands2-dn.in
	cd ..
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
		if [ $s == 'XC' ]; then
			for i in 'N' 'P' 'Z'; do
				mkdir -p $i
				cd $i
				mkdir -p nscf
				mkdir -p bands
				copy_files
				gen_csh
				dupl_spnpol
				modify_lines
				cd ..
			done
		else
			for i in 'X' 'Y' 'Z'; do
				mkdir -p $i
				cd $i
				mkdir -p nscf
				mkdir -p bands
				copy_files
				gen_csh
				dupl_spnpol
				modify_lines
				cd ..
			done
		fi
		cd ..
	done
	cd ..
done
