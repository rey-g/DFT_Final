#!/bin/bash

modify_lines() {
	# check existence of additional OUTPUT files and copy relaxed coordinates
	printf $i"\n"
	for n in '3' '2' ''; do
		if [ -e OUTPUT_*${n} ]; then
			# copy ATOMIC_POSITIONS section from OUTPUT_*
			COORD=$(grep -B 33 "End final coordinates" OUTPUT_*${n})
			printf "Success!\n\n"
			break
		fi
	done
	
	# edit basic parameters
	sed -i 's/relax/scf/' *scf.in
	sed -i -e '/&IONS/,/\//d' *scf.in
	sed -i 's/4 4 1/16 16 1/' *scf.in
	sed -i '/diagonalization/d' *scf.in
	
	# insert relaxed coordinates
	sed -i '/ATOMIC_POSITIONS/,+32d' *scf.in
	awk -v s="${COORD}" '/K_POINTS/{print s} {print}' *scf.in > tmp && mv tmp *scf.in
	sed -i '/End final/d' *scf.in
	
	# copy scf to bands and nscf
	cp *scf.in ./nscf/INPUT_G${X}_${g}t${sl}-nscf.in
	cp *scf.in ./bands/INPUT_G${X}_${g}t${sl}-bands1.in
	cd bands
		sed -i 's/scf/bands/' *bands1.in
		sed -i 's/smearing/tetrahedra/' *bands1.in
		sed -i 's/16 16 1/20 20 1/' *bands1.in
	cd ../nscf/
		sed -i 's/scf/nscf/' *nscf.in
		sed -i 's/smearing/tetrahedra/' *nscf.in
		sed -i 's/16 16 1/20 20 1/' *nscf.in
	cd ..
	
	# pp input files
	#sed -i 's/_chg/_chg-up/' *pp-up.in
	#sed -i 's/spin_component = 0/spin_component = 1/' *pp-up.in
	#sed -i 's/_chg/_chg-dn/' *pp-dn.in
	#sed -i 's/spin_component = 0/spin_component = 2/' *pp-dn.in
	
	#cd bands
	# bands input files
	#sed -i 's/_bands/_bands-up/' *bands2-up.in
	#sed -i '6i \ \ \ \ spin_component = 1 ,\n\ \ \ \ no_overlap = .true. ,' *bands2-up.in
	#sed -i 's/_bands/_bands-dn/' *bands2-dn.in
	#sed -i '6i \ \ \ \ spin_component = 2 ,\n\ \ \ \ no_overlap = .true. ,' *bands2-dn.in
	#cd ..
}

copy_files() {
	# copy relax.in to [scf/nscf/bands1].in
	cp *relax.in INPUT_G${X}_${g}t${sl}-scf.in
}

# halogen
read -p 'Halogen [F/Cl/Br/I]: ' X
read -p 'Geometry [ip/op]: ' g

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
	copy_files
	modify_lines
	cd ..
done
cd ..
